# frozen_string_literal: true

unless Rails.env.development?
  WxPay.appid = Settings.wx_pay.app_id
  WxPay.key = Settings.wx_pay.api_key
  WxPay.mch_id = Settings.wx_pay.mch_id

  # 线上staging和production使用的是不同的微信公众号，对应的不同的微信商户，所以得用不同的证书
  # 本地无法调试微信支付，无论用哪个，给个正确的路径不出错就行了

  api_cert = if Rails.env.staging?
               File.read(Rails.root.to_s + '/config/cert/staging/apiclient_cert.p12')
             else
               File.read(Rails.root.to_s + '/config/cert/production/apiclient_cert.p12')
             end

  WxPay.set_apiclient_by_pkcs12(api_cert, Settings.wx_pay.mch_id)
  WxPay.extra_rest_client_options = { timeout: 1000, open_timeout: 3 }
end
