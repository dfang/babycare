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
    elsif resource.diagnosed?
      body_text = '支付余款'
    end

    # 预约定金
    if resource.out_trade_prepay_no.blank? && resource.reserved?
      resource.out_trade_prepay_no = "prepay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
      resource.save
    end

    # 支付余款
    if resource.out_trade_pay_no.blank? && resource.diagnosed?
      resource.out_trade_pay_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
      resource.save
    end

    out_trade_no = resource.out_trade_pay_no || resource.out_trade_prepay_no

    if resource.reserved? || resource.diagnosed?

        test_params = {
          body: body_text,
          out_trade_no: out_trade_no,
          total_fee: 1,
          spbill_create_ip: '60.205.110.67',
          notify_url: 'http://wx.yhuan.cc/my/patients/reservations/payment_notify',
          trade_type: 'JSAPI',
          openid: current_wechat_authentication.uid
        }

        options = {
                    appid: Settings.wx_pay.app_id,
                    mch_id: Settings.wx_pay.mch_id,
                    key: Settings.wx_pay.key,
                    noncestr: SecureRandom.hex,
                    timestamp: DateTime.now.to_i
                  }

        result = WxPay::Service.invoke_unifiedorder(test_params, options)

        p 'invoke_unifiedorder result is .......... '
        p result

        # binding.remote_pry

        # js_request_params = WxPay::Service.generate_js_pay_req(test_params.merge({
        #             noncestr: options[:noncestr],
        #             package: "prepay_id=#{result['prepay_id']}",
        #             prepayid: result['prepay_id']
        #           }), appid: Settings.wx_pay.app_id )
        # p 'generate_js_pay_req is '

        # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
        js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: options[:noncestr], timestamp: options[:timestamp], url: request.url }.sort.map do |k,v|
                            "#{k}=#{v}" if v != "" && !v.nil?
                          end.compact.join('&')

        p 'js_sdk_signature string ..........'
        p js_sdk_signature_str

        pay_sign_str = {
                      appId: Settings.wx_pay.app_id,
                      nonceStr: options[:noncestr],
                      timeStamp: options[:timestamp],
                      package: "prepay_id=#{result['prepay_id']}",
                      signType: 'MD5'
                  }.sort.map do |k,v|
                            "#{k}=#{v}" if v != "" && !v.nil?
                          end.compact.join('&').concat("&key=#{Settings.wx_pay.key}")

        p  'pay_sign is .....'
        p  pay_sign_str



        # 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
        @order_params = {
          appId:     result['appid'] || Settings.wx_pay.app_id,
          timeStamp: options[:timestamp],
          nonceStr:  options[:noncestr],
          signType:  "MD5",
          package:   "prepay_id=#{result['prepay_id']}",
          sign:      Digest::SHA1.hexdigest(js_sdk_signature_str),
          paySign:   Digest::MD5.hexdigest(pay_sign_str).upcase()
        }

        p '@order_params is .........'
        p @order_params
    end

  end

  def payment
    if request.put?

      @total_fee = params[:reservation][:total_fee]
      resource.total_fee = @total_fee.to_f
      resource.save!

      redirect_to pay_my_patients_reservation_path(resource) and return
    end
  end

  def pay

    if resource.total_fee.blank?
      redirect_to my_patients_reservation_path(resource) and return
    end

    out_trade_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
    payment_params = {
      body: "支付咨询费用",
      out_trade_no: out_trade_no,
      total_fee: resource.total_fee,
      spbill_create_ip: '60.205.110.67',
      notify_url: 'http://wx.yhuan.cc/my/patients/reservations/payment_notify',
      trade_type: 'JSAPI',
      openid: current_wechat_authentication.uid
    }

    options = {
                appid:      Settings.wx_pay.app_id,
                mch_id:     Settings.wx_pay.mch_id,
                key:        Settings.wx_pay.key,
                noncestr:   SecureRandom.hex,
                timestamp:  DateTime.now.to_i
              }

    result = WxPay::Service.invoke_unifiedorder(payment_params, options)

    p 'invoke_unifiedorder result is .......... '
    p result

    # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
    js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: options[:noncestr], timestamp: options[:timestamp], url: request.url }.sort.map do |k,v|
                        "#{k}=#{v}" if v != "" && !v.nil?
                      end.compact.join('&')

    p 'js_sdk_signature string ..........'
    p js_sdk_signature_str

    pay_sign_str =  {
                      appId:      Settings.wx_pay.app_id,
                      nonceStr:   options[:noncestr],
                      timeStamp:  options[:timestamp],
                      package:    "prepay_id=#{result['prepay_id']}",
                      signType:   "MD5"
                    }.sort.map do |k,v|
                        "#{k}=#{v}" if v != "" && !v.nil?
                      end.compact.join('&').concat("&key=#{Settings.wx_pay.key}")

    p  'pay_sign is .....'
    p  pay_sign_str

    # 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
    @order_params = {
      appId:     result['appid'] || Settings.wx_pay.app_id,
      timeStamp: options[:timestamp],
      nonceStr:  options[:noncestr],
      signType:  "MD5",
      package:   "prepay_id=#{result['prepay_id']}",
      sign:      Digest::SHA1.hexdigest(js_sdk_signature_str),
      paySign:   Digest::MD5.hexdigest(pay_sign_str).upcase()
    }
  end

  def payment_test
  end

  def payment_notify
    # 改变订单状态
    # binding.remote_pry
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
      # order_query_result
      # {
      #   "return_code"=>"SUCCESS",
      #   "return_msg"=>"OK",
      #   "appid"=>"wxa887ef8490361f68",
      #   "mch_id"=>"1368072702",
      #   "nonce_str"=>"PbbsrwpIR9P6ViZp",
      #   "sign"=>"C81ECDA67B84AC9D1A222F5CAD2C050A",
      #   "result_code"=>"SUCCESS",
      #   "openid"=>"ox-t3s08e-Av2rUlE2a2i2ITR0XY",
      #   "is_subscribe"=>"Y",
      #   "trade_type"=>"JSAPI",
      #   "bank_type"=>"CFT",
      #   "total_fee"=>"1",
      #   "fee_type"=>"CNY",
      #   "transaction_id"=>"4007612001201608111132486401",
      #   "out_trade_no"=>"prepay56471",
      #   "attach"=>"",
      #   "time_end"=>"20160811225354",
      #   "trade_state"=>"SUCCESS",
      #   "cash_fee"=>"1"
      #  }

      p 'find reservation'
      reservation = Reservation.where("out_trade_pay_no = ? OR out_trade_prepay_no = ?", order_query_result["out_trade_no"], order_query_result["out_trade_no"]).first

      p reservation
      p 'trigger prepay or pay event'

      if reservation.reserved?

        reservation.prepay! do
          # user prepay and send sms to notify doctor prepaid
          params1 = [ reservation.doctor_user_name, reservation.reserved_time, reservation.reserved_location ]
          params2 = [ reservation.patient_user_name, reservation.reserved_time, reservation.reserved_location]
          SmsNotifyUserWhenPrepaidJob.perform_now(reservation.patient_user_phone, params1)
          SmsNotifyDoctorWhenPrepaidJob.perform_now(reservation.doctor_user_phone, params2)
        end

      elsif reservation.diagnosed?

        reservation.pay! do
          # user paid and send sms to doctors
          params = [reservation.patient_user_name]
          SmsNotifyDoctorWhenPaidJob.perform_now(reservation.doctor_user_phone, params)
        end

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
