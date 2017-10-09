# frozen_string_literal: true

class Wx::WxpayController < ApplicationController
  # protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  skip_before_action :verify_authenticity_token
  before_action :query_order_result, only: :payment_notify
  before_action :query_payment_reservation, only: :payment_notify

  # 改变订单状态
  # // 示例报文
  # // String xml = "<xml><appid><![CDATA[wxb4dc385f953b356e]]></appid><bank_type><![CDATA[CCB_CREDIT]]></bank_type><cash_fee><![CDATA[1]]></cash_fee><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id><![CDATA[1228442802]]></mch_id><nonce_str><![CDATA[1002477130]]></nonce_str><openid><![CDATA[o-HREuJzRr3moMvv990VdfnQ8x4k]]></openid><out_trade_no><![CDATA[1000000000051249]]></out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><sign><![CDATA[1269E03E43F2B8C388A414EDAE185CEE]]></sign><time_end><![CDATA[20150324100405]]></time_end><total_fee>1</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id><![CDATA[1009530574201503240036299496]]></transaction_id></xml>";
  def payment_notify
    Rails.logger.info 'trigger prepay or pay event'
    if @reservation && @reservation.pending?
      @reservation.prepay!
    elsif @reservation && @reservation.diagnosed?
      @reservation.pay!
    end
  end

  private

  def query_order_result
    response_obj = Hash.from_xml(request.body.read)
    p 'payment notify result'
    p response_obj
    params = {
      transaction_id: response_obj['xml']['transaction_id']
    }
    options = WxApp::WxJsSDK.generate_payment_options
    @order_query_result = WxPay::Service.order_query(params, options)
    Rails.logger.info "order query result .......\n #{@order_query_result}"
    return unless @order_query_result['return_code'] == 'SUCCESS'
  end

  def query_payment_reservation
    @reservation = Reservation.where('out_trade_pay_no = ? OR out_trade_prepay_no = ?', @order_query_result['out_trade_no'], @order_query_result['out_trade_no']).first
    Rails.logger.info @reservation
  end
end
