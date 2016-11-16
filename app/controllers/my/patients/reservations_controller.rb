require "rexml/document"

class My::Patients::ReservationsController < InheritedResources::Base
  before_action ->{ authenticate_user!( force: true ) }, :except => [:payment_notify]
  before_action :check_is_verified_doctor
  custom_actions :collection => [ :reservations, :status, :payment_notify, :payment_test ]
  before_action :deny_doctors, only: :show

  skip_before_action :verify_authenticity_token, only: :payment_notify
  skip_before_action :authenticate_user!, only: :payment_notify
  skip_before_action :check_is_verified_doctor, only: :payment_notify

  def reservations
  end

  def index
    @reservations = current_user.reservations.order('created_at DESC')
  end

  def status
  end

  def show
    if resource.reserved?
      body_text = '预约定金'
      fee = Settings.wx_pay.prepay_amount
      resource.prepay_fee = fee
    elsif resource.diagnosed?
      body_text = '支付咨询费用'
      fee = Settings.wx_pay.pay_amount
      resource.pay_fee = fee
    end

    # 预约定金
    if resource.out_trade_prepay_no.blank? && resource.reserved?
      resource.out_trade_prepay_no = "prepay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
    end

    # 支付余款
    if resource.out_trade_pay_no.blank? && resource.diagnosed?
      resource.out_trade_pay_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
    end

    out_trade_no = resource.out_trade_pay_no || resource.out_trade_prepay_no

    resource.save!

    if resource.reserved? || resource.diagnosed?

        payment_params = WxApp::WxPay.generate_payment_params(body_text, out_trade_no, fee, request.ip, Settings.wx_pay.payment_notify_url, current_wechat_authentication.uid)
        options = WxApp::WxPay.generate_payment_options


        result = WxPay::Service.invoke_unifiedorder(payment_params, options)
        p   'invoke_unifiedorder result: payment_params is .......... '
        p   result

        # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
        js_sdk_signature_str = WxApp::WxPay.generate_js_sdk_signature_str(options[:noncestr], options[:timestamp], request.url)
        p   'js_sdk_signature string ..........'
        p   js_sdk_signature_str


        pay_sign_str = WxApp::WxPay.generate_pay_sign_str(options, result['prepay_id'])
        p   'pay_sign_str is .....'
        p   pay_sign_str


        # 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
        @order_params = {
          appId:     result['appid'] || Settings.wx_pay.app_id,
          timeStamp: options[:timestamp],
          nonceStr:  options[:noncestr],
          signType:  "MD5",
          package:   "prepay_id=#{result['prepay_id']}",
          sign:      js_sdk_signature_str,
          paySign:   pay_sign_str
        }

        p '@order_params is .........'
        p @order_params
    end

  end

  # def payment
  #   if request.put?
  #     @total_fee = params[:reservation][:total_fee].to_f
  #     # 微信支付的单位是分，不接受小数点，所以这里乘以100
  #     resource.total_fee = (@total_fee * 100).to_i
  #     resource.save!
  #
  #     redirect_to wxpay_my_patients_reservations_path(reservation_id: resource.id) and return
  #   end
  # end

  # 输入数字金额支付页面暂时用不上
  # def wxpay
  #   reservation = Reservation.find_by(id: params[:reservation_id])
  #   body_text = "支付咨询费用"
  #   if reservation.blank?
  #     redirect_to my_patients_reservations_path and return
  #   end
  #
  #   if reservation.present? && reservation.total_fee.blank?
  #     redirect_to my_patients_reservation_path(reservation) and return
  #   end
  #
  #   out_trade_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
  #   payment_params = WxApp::WxPay.generate_payment_params(body_text, out_trade_no, reservation.total_fee, request.ip, Settings.wx_pay.payment_notify_url, current_wechat_authentication.uid)
  #
  #   options = WxApp::WxPay.generate_payment_options
  #   result = WxPay::Service.invoke_unifiedorder(payment_params, options)
  #
  #   p 'invoke_unifiedorder result is .......... '
  #   p result
  #
  #   # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
  #   js_sdk_signature_str = WxApp::WxPay.generate_js_sdk_signature_str(options[:noncestr], options[:timestamp], request.url)
  #   p   'js_sdk_signature string ..........'
  #   p   js_sdk_signature_str
  #
  #   pay_sign_str = WxApp::WxPay.generate_pay_sign_str(options, result['prepay_id'])
  #   p   'pay_sign_str is .....'
  #   p   pay_sign_str
  #
  #   # 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
  #   @order_params = {
  #     appId:     result['appid'] || Settings.wx_pay.app_id,
  #     timeStamp: options[:timestamp],
  #     nonceStr:  options[:noncestr],
  #     signType:  "MD5",
  #     package:   "prepay_id=#{result['prepay_id']}",
  #     sign:      js_sdk_signature_str,
  #     paySign:   pay_sign_str
  #   }
  # end

  # def payment_test
  # end

  def payment_notify
    # 改变订单状态
    # // 示例报文
    # // String xml = "<xml><appid><![CDATA[wxb4dc385f953b356e]]></appid><bank_type><![CDATA[CCB_CREDIT]]></bank_type><cash_fee><![CDATA[1]]></cash_fee><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id><![CDATA[1228442802]]></mch_id><nonce_str><![CDATA[1002477130]]></nonce_str><openid><![CDATA[o-HREuJzRr3moMvv990VdfnQ8x4k]]></openid><out_trade_no><![CDATA[1000000000051249]]></out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><sign><![CDATA[1269E03E43F2B8C388A414EDAE185CEE]]></sign><time_end><![CDATA[20150324100405]]></time_end><total_fee>1</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id><![CDATA[1009530574201503240036299496]]></transaction_id></xml>";
    response_obj = Hash.from_xml(request.body.read)
    p 'payment notify result'
    p response_obj
    options_to_sign = {
                        appid: Settings.wx_pay.app_id,
                        mch_id: Settings.wx_pay.mch_id,
                        transaction_id: response_obj["xml"]["transaction_id"],
                        nonce_str: SecureRandom.hex,
                        out_trade_no: response_obj["xml"]["out_trade_no"]
                      }
    strings_to_sign = options_to_sign.sort.map do |k,v|
                          "#{k}=#{v}" if v != "" && !v.nil?
                        end.compact.join('&').concat("&key=#{Settings.wx_pay.key}")


    order_query_result =  WxPay::Service.order_query(options_to_sign.merge(sign: Digest::MD5.hexdigest(strings_to_sign)))

    p 'order query result .......'
    p order_query_result
    p order_query_result["out_trade_no"]
    if order_query_result["return_code"] == "SUCCESS"

      p 'find reservation'
      reservation = Reservation.where("out_trade_pay_no = ? OR out_trade_prepay_no = ?", order_query_result["out_trade_no"], order_query_result["out_trade_no"]).first

      p reservation
      p 'trigger prepay or pay event'

      if reservation.reserved?

        reservation.prepay!

      elsif reservation.diagnosed?

        reservation.pay!

      end
    end
  end

  private

  # todo: fix_this
  def check_is_verified_doctor
    if current_user.is_verified_doctor?
      redirect_to my_patients_status_path and return
    end
  end

  def deny_doctors
    unless resource.user_a == current_user.id
      # todo: redirect_to page with permission denied message
      flash[:error] = "你是医生不能访问用户区域"
      redirect_to global_denied_path and return
    end
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end
end
