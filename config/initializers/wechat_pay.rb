WxPay.appid = Settings.wx_pay.app_id
WxPay.key = Settings.wx_pay.api_key
WxPay.mch_id = Settings.wx_pay.mch_id


api_cert = File.read("#{Rails.root}" + "/config/cert/apiclient_cert.p12")
WxPay.set_apiclient_by_pkcs12(api_cert, Settings.wx_pay.mch_id)

WxPay.extra_rest_client_options = {timeout: 1000, open_timeout: 3}
