require 'uri'

class WxpayController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  respond_to :json, :js, :xml

  def config
    appId           =  Settings.wx_pay.app_id
    nonceStr        =  SecureRandom.hex
    timestamp       =  DateTime.now.to_i
    signature       =  WxApp::WxPay.generate_js_sdk_signature_str(nonceStr, timestamp, URI.unescape(params[:url]))

    render json: {
        appId: appId,
        key: Settings.wx_pay.key,
        mch_id: Settings.wx_pay.mch_id,
        timestamp: timestamp.to_s,
        nonceStr: nonceStr,
        signature: signature,
        jsApiList: ['checkJsApi', 'chooseWXPay', 'chooseImage', 'uploadImage', 'downloadImage', 'previewImage', 'openLocation', 'getLocation']
      }
  end
end
