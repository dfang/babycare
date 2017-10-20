# frozen_string_literal: true

require 'rexml/document'

class Patients::ReservationsController < Patients::BaseController
  # before_action ->{ authenticate_user!( force: true ) }, :except => [:payment_notify]
  # skip_before_action :deny_doctors, only: :payment_notify
  # skip_before_action :verify_authenticity_token, only: :payment_notify
  # skip_before_action :authenticate_user!, only: :payment_notify
  # skip_before_action :check_is_verified_doctor, only: :payment_notify
  # custom_actions :collection => [ :payment_notify, :payment_test ], :member => [ :status ]
  custom_actions member: [:status]

  # def reservations
  # end

  def index
    @reservations = current_user.reservations.order('created_at DESC')
  end

  def status; end

  def show; end

  def update
    if params.key?(:event) && params[:event] == 'complete'
      resource.diagnose!
      redirect_to wx_payment_path(reservation_id: resource) and return
    else
      super
    end
  end

  # FIXME
  # rubocop:disable Metrics/MethodLength
  def pay
  end

  def latest
    latest_pending_reservation = current_user.reservations.to_prepay.order('CREATED_AT DESC').first
    if latest_pending_reservation.present?
      redirect_to patients_reservation_path(latest_pending_reservation)
    else
      redirect_to patients_reservations_path
    end
  end

  # 输入数字金额支付页面暂时用不上
  # def wxpay
  #   reservation = Reservation.find_by(id: params[:reservation_id])
  #   body_text = "支付咨询费用"
  #   if reservation.blank?
  #     redirect_to patients_reservations_path and return
  #   end
  #
  #   if reservation.present? && reservation.total_fee.blank?
  #     redirect_to patients_reservation_path(reservation) and return
  #   end
  #
  #   out_trade_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100000)}"
  #   payment_params = WxApp::WxJsSDK.generate_payment_params(body_text, out_trade_no, reservation.total_fee, request.ip, Settings.wx_pay.payment_notify_url, current_wechat_authentication.uid)
  #
  #   options = WxApp::WxJsSDK.generate_payment_options
  #   result = WxPay::Service.invoke_unifiedorder(payment_params, options)
  #
  #   p 'invoke_unifiedorder result is .......... '
  #   p result
  #
  #   # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
  #   js_sdk_signature_str = WxApp::WxJsSDK.generate_js_sdk_signature_str(options[:noncestr], options[:timestamp], request.url)
  #   p   'js_sdk_signature string ..........'
  #   p   js_sdk_signature_str
  #
  #   pay_sign_str = WxApp::WxJsSDK.generate_pay_sign_str(options, result['prepay_id'])
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

  private

  def current_wechat_authentication
    current_user.authentications.find_by(provider: 'wechat')
  end
end
