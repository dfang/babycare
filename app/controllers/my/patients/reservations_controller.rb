require "rexml/document"

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
    test_params = {
      body: '测试商品',
      out_trade_no: "test#{SecureRandom.random_number(100000)}",
      total_fee: 1,
      spbill_create_ip: '60.205.110.67',
      notify_url: 'http://wx.yhuan.cc/reservations/public',
      trade_type: 'JSAPI',
      openid: 'ox-t3s_BIGA0KgFWzwNrnFE-pE28'
    }

    options = {
                appid: Settings.wx_pay.app_id,
                mch_id: Settings.wx_pay.mch_id,
                key: Settings.wx_pay.key,
                noncestr: SecureRandom.hex,
                timestamp: DateTime.now.to_i
              }

    result = WxPay::Service.invoke_unifiedorder(test_params, options)

    p 'invoke_unifiedorder result is '
    p result

    # js_request_params = WxPay::Service.generate_js_pay_req(test_params.merge({
    #             noncestr: options[:noncestr],
    #             package: "prepay_id=#{result['prepay_id']}",
    #             prepayid: result['prepay_id']
    #           }), appid: Settings.wx_pay.app_id )
    # p 'generate_js_pay_req is '

    stringA = {
                  appId: Settings.wx_pay.app_id,
                  nonceStr: options[:noncestr],
                  timeStamp: options[:timestamp],
                  package: "prepay_id=#{result['prepay_id']}",
                  signType: 'MD5'
              }.sort.map do |k,v|
                        "#{k}=#{v}" if v != "" && !v.nil?
                      end.compact.join('&')

    sign_str = stringA + "&key=#{Settings.wx_pay.key}"

    p sign_str

    sign = Digest::MD5.hexdigest(sign_str).upcase()
    p 'sign is .....'
    p sign

    # // 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
    @order_params = {
      appId:     result['appid'] || Settings.wx_pay.app_id,
      timeStamp: options[:timestamp],
      nonceStr:  options[:noncestr],
      signType:  "MD5",
      package:   "prepay_id=#{result['prepay_id']}",
      paySign:   sign
    }

    # WxPay::Service::generate_js_pay_req

    p '@order_params is .........'
    p @order_params

  end

  private

  def check_is_verified_doctor
    if current_user.is_verified_doctor?
      redirect_to my_patients_status_path and return
    end
  end
end
