class My::Patients::ReservationsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ]

  def reservations
  end

  def index
    @reservations = current_user.self_reservations
  end

  def status
  end

  def show
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

  def check_is_verified_doctor
    if current_user.is_verified_doctor?
      redirect_to my_patients_status_path and return
    end
  end
end
