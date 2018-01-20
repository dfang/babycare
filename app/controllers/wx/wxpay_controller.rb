# frozen_string_literal: true

class Wx::WxpayController < ApplicationController
  # protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  skip_before_action :verify_authenticity_token
  before_action :find_reservation, only: :payment
  before_action :authenticate_user!, only: :payment
  before_action :query_order_result, only: :payment_notify
  before_action :query_payment_reservation, only: :payment_notify

  def payment
    if @reservation.to_prepay?
      body_text = '预约定金'
      fee = (Settings.wx_pay.prepay_amount * 100).to_i
      @reservation.prepay_fee = fee
    elsif @reservation.to_pay?
      body_text = '支付咨询费用'
      fee = (Settings.wx_pay.pay_amount * 100).to_i
      @reservation.pay_fee = fee
    else
      redirect_to(patients_reservation_path(@reservation)) && return
    end

    Rails.logger.info "需要支付的费用fee是#{fee}分"

    # 预约定金 TO_BE_TESTED
    # if @reservation.out_trade_prepay_no.blank? && @reservation.reserved?
    if @reservation.to_prepay?
      @reservation.out_trade_prepay_no = "prepay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100_000)}"
    end

    # 支付余款 TO_BE_TESTED
    # if @reservation.out_trade_pay_no.blank? && @reservation.diagnosed?
    if @reservation.to_pay?
      @reservation.out_trade_pay_no = "pay_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100_000)}"
    end

    out_trade_no = @reservation.out_trade_pay_no || @reservation.out_trade_prepay_no

    Rails.logger.info "out_trade_no 是 #{out_trade_no}"

    # 保存商户订单号
    @reservation.save!

    if @reservation.to_prepay? || @reservation.to_pay?
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
        paySign:   js_pay_params.delete(:paySign),
        reservation_id: @reservation.id
      }

      Rails.logger.info '@order_params is ......... \n'
      Rails.logger.info @order_params
    end
  end

  # 改变订单状态
  # // 示例报文
  # // String xml = "<xml><appid><![CDATA[wxb4dc385f953b356e]]></appid><bank_type><![CDATA[CCB_CREDIT]]></bank_type><cash_fee><![CDATA[1]]></cash_fee><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id><![CDATA[1228442802]]></mch_id><nonce_str><![CDATA[1002477130]]></nonce_str><openid><![CDATA[o-HREuJzRr3moMvv990VdfnQ8x4k]]></openid><out_trade_no><![CDATA[1000000000051249]]></out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><sign><![CDATA[1269E03E43F2B8C388A414EDAE185CEE]]></sign><time_end><![CDATA[20150324100405]]></time_end><total_fee>1</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id><![CDATA[1009530574201503240036299496]]></transaction_id></xml>";
  def payment_notify
    if @reservation&.to_prepay?
      Rails.logger.info 'trigger prepay event'
      @reservation.prepay!
    elsif @reservation&.to_pay?
      Rails.logger.info 'trigger pay event'
      @reservation.pay!
    end
    head :ok
  end

  private

  def find_reservation
    @reservation ||= Reservation.find_by(id: params[:reservation_id])
  end

  def query_order_result
    response_obj = Hash.from_xml(request.body.read)
    Rails.logger.info 'payment notify result ....'
    p response_obj
    params = {
      transaction_id: response_obj['xml']['transaction_id']
    }
    options = WxApp::WxJsSDK.generate_payment_options
    Rails.logger.info "params is \n #{params}"
    Rails.logger.info "options is \n #{options}"
    @order_query_result = WxPay::Service.order_query(params, options)
    Rails.logger.info "order query result ....... \n #{@order_query_result}"
    return unless @order_query_result['return_code'] == 'SUCCESS'
  end

  def query_payment_reservation
    @reservation = Reservation.where('out_trade_pay_no = ? OR out_trade_prepay_no = ?', @order_query_result['out_trade_no'], @order_query_result['out_trade_no']).first
    Rails.logger.info @reservation
  end
end
