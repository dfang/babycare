class ReservationsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }

  custom_actions :resource => :wxpay_test
  before_action :rectrict_access
  before_action :deny_doctors
  skip_before_action :deny_doctors, only: [ :public, :show, :status ]

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_a = current_user.id
    create! {
      status_reservation_path(resource)
    }
  end

  def public
    @is_doctor = current_user.doctor.present?
    @reservations = Reservation.pending.order("created_at DESC")
  end

  def new
    @appId = Settings.wx_pay.app_id
    @nonceStr = SecureRandom.hex
    @timestamp =  DateTime.now.to_i
    js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: @nonceStr, timestamp: @timestamp, url: request.url }.sort.map do |k,v|
                        "#{k}=#{v}" if v != "" && !v.nil?
                      end.compact.join('&')
    @signature = Digest::SHA1.hexdigest(js_sdk_signature_str)

    super
  end

  def restricted
  end

  def status
  end

  def wxpay_test
    params = {
      body: '测试商品',
      out_trade_no: 'test003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://wx.yhuan.cc/wcpay/notify',
      trade_type: 'JSAPI',
      openid: 'ox-t3s_BIGA0KgFWzwNrnFE-pE28'
    }
    result = WxPay::Service.invoke_unifiedorder params

    @order_params = {
      appId: Settings.wx_pay.appid,
      timeStamp: DateTime.now.utc.to_i,
      nonceStr:  SecureRandom.hex,
      signType:  "MD5",
      package:   "prepay_id=#{result[:prepay]}",
      paySign:   "#{result[:sign]}"
    }

    # WxPay::Service::generate_js_pay_req

    p '@order_params'
    p @order_params
  end

  private

  def rectrict_access
    access = AccessWhitelist.find_by(uid: current_user.wechat_authentication.try(:uid))
    if access.blank?
      redirect_to restricted_reservations_path
    end
  end

  def reservation_params
    params.require(:reservation).permit!
  end

  def deny_doctors
    if current_user.doctor.present? && current_user.doctor.verified?
      flash[:error] = "你是医生不能访问该页面"
      redirect_to global_denied_path and return
    end
  end
end
