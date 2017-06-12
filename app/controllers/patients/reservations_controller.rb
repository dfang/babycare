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

  # FIXME
  # rubocop:disable Metrics/MethodLength
  def show
    if resource.pending?
      body_text = '预约定金'
      fee = (Settings.wx_pay.prepay_amount * 100).to_i
      resource.prepay_fee = fee
    elsif resource.diagnosed?
      body_text = '支付咨询费用'
      fee = (Settings.wx_pay.pay_amount * 100).to_i
      resource.pay_fee = fee
    end

    Rails.logger.info "需要支付的费用fee是#{fee}分"

    # 预约定金 TO_BE_TESTED
    # if resource.out_trade_prepay_no.blank? && resource.reserved?
    if resource.pending?
      resource.out_trade_prepay_no = "prepay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100_000)}"
    end

    # 支付余款 TO_BE_TESTED
    # if resource.out_trade_pay_no.blank? && resource.diagnosed?
    if resource.diagnosed?
      resource.out_trade_pay_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100_000)}"
    end

    out_trade_no = resource.out_trade_pay_no || resource.out_trade_prepay_no

    Rails.logger.info "out_trade_no 是 #{out_trade_no}"

    resource.save!

    if resource.pending? || resource.diagnosed?

      payment_params = WxApp::WxJsSDK.generate_payment_params(body_text, out_trade_no, fee, request.ip, Settings.wx_pay.payment_notify_url, 'JSAPI')
      options = WxApp::WxJsSDK.generate_payment_options

      # 微信支付的坑
      # total_fee 必须是整数的分，不能是float
      # JSAPI支付必须传openid
      payment_params[:openid] = current_wechat_authentication.uid

      Rails.logger.info  "payment_params is \n#{payment_params}"
      Rails.logger.info  "options is \n#{options}"

      result = ::WxPay::Service.invoke_unifiedorder(payment_params, options)
      Rails.logger.info "invoke_unifiedorder result is \n#{result}"

      # 用在wx.config 里的，不要和 wx.chooseWxPay(里的那个sign参数搞混了)
      # js_sdk_signature_str = WxApp::WxJsSDK.generate_js_sdk_signature_str(options[:noncestr], options[:timestamp], request.url)
      # p  "js_sdk_signature string ..........\n #{js_sdk_signature_str} "

      # pay_sign_str = WxApp::WxJsSDK.generate_pay_sign_str(options, result['prepay_id'])
      # p   'pay_sign_str is .....'
      # p   pay_sign_str

      js_pay_params = ::WxPay::Service.generate_js_pay_req({ prepayid: result['prepay_id'], noncestr: options[:noncestr] }, options)

      # 这里不能用options[:app_id], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
      @order_params = {
        appId:     Settings.wx_pay.app_id,
        timeStamp: js_pay_params.delete(:timeStamp),
        nonceStr:  js_pay_params.delete(:nonceStr),
        signType:  js_pay_params.delete(:signType),
        package:   js_pay_params.delete(:package),
        paySign:   js_pay_params.delete(:paySign)
      }

      Rails.logger.info '@order_params is .........'
      Rails.logger.info @order_params
    end
  end

  def latest
    latest_pending_reservation = current_user.reservations.pending.order('CREATED_AT DESC').first
    if latest_pending_reservation.present?
      redirect_to patients_reservation_path(latest_pending_reservation)
    else
      redirect_to patients_reservations_path
    end
  end

  # def payment
  #   if request.put?
  #     @total_fee = params[:reservation][:total_fee].to_f
  #     # 微信支付的单位是分，不接受小数点，所以这里乘以100
  #     resource.total_fee = (@total_fee * 100).to_i
  #     resource.save!
  #
  #     redirect_to wxpay_patients_reservations_path(reservation_id: resource.id) and return
  #   end
  # end

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
    current_user.authentications.where(provider: 'wechat').first
  end
end
