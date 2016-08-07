# WechatPay.app_id       = Settings.wx_pay.app_id
# WechatPay.app_secret   = Settings.wx_pay.app_secret
# WechatPay.pay_sign_key = Settings.wx_pay.pay_sign_key
# WechatPay.partner_id   = Settings.wx_pay.partner_id
# WechatPay.partner_key  = Settings.wx_pay.partner_key

WxPay.appid = Settings.wx_pay.appid
WxPay.key = Settings.wx_pay.key
WxPay.mch_id = Settings.wx_pay.mch_id


# api_cert = File.binread("#{Rails.root}" + "/config/apiclient_cert.p12")
# WxPay.set_apiclient_by_pkcs12(api_cert, Settings.wx_pay.key)
WxPay.extra_rest_client_options = {timeout: 1000, open_timeout: 3}

# PKCS12_parse: mac verify failure (OpenSSL::PKCS12::PKCS12Error) #1



#
# function onBridgeReady(){
#    WeixinJSBridge.invoke(
#        'getBrandWCPayRequest', {
#            "appId" ： "wx2421b1c4370ec43b",     //公众号名称，由商户传入
#            "timeStamp"："",         //时间戳，自1970年以来的秒数
#            "nonceStr" ： "e61463f8efa94090b1f366cccfbbb444", //随机串
#            "package" ： "prepay_id=u802345jgfjsdfgsdg888",
#            "signType" ： "MD5",         //微信签名方式：
#            "paySign" ： "70EA570631E4BB79628FBCA90534C63FF7FADD89" //微信签名
#        },
#        function(res){
#            if(res.err_msg == "get_brand_wcpay_request：ok" ) {}     // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。
#        }
#    );
# }
#
#
# if (typeof WeixinJSBridge == "undefined"){
#    if( document.addEventListener ){
#        document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
#    }else if (document.attachEvent){
#        document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
#        document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
#    }
# }else{
#    onBridgeReady();
# }
