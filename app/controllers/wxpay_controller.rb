require 'uri'

class WxpayController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? }
  respond_to :json, :js, :xml

  def config_jssdk
    # 在rails 5 里面这里绝对不能叫config, 否则 SystemStackError (stack level too deep)

    appId           =  Settings.wx_pay.app_id
    nonceStr        =  SecureRandom.hex
    timestamp       =  DateTime.now.to_i
    js_sdk_signature_str       =  ::WxApp::WxPay.generate_js_sdk_signature_str(nonceStr, timestamp, url)
    p js_sdk_signature_str

    render json: {
        appId: appId,
        key: Settings.wx_pay.api_key,
        mch_id: Settings.wx_pay.mch_id,
        timestamp: timestamp.to_s,
        nonceStr: nonceStr,
        signature: js_sdk_signature_str,
        jsApiList: ['checkJsApi', 'chooseWXPay', 'chooseImage', 'uploadImage', 'downloadImage', 'previewImage', 'openLocation', 'getLocation']
      }
  end
end
