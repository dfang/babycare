import $ from 'jquery';
import wx from 'wechat-jssdk-promise';

wx.getLocalImgDataAsync = function (params) {
  params = params || {};
  return new Promise(function (resolve, reject) {
    params.success = resolve;
    params.fail = function (res) {
      reject(new Error(res.errMsg));
    };
    wx.getLocalImgData(params);
  });
};

// export let config_js_sdk = (url) =>
let url = location.href.split('#')[0]
$.ajax({
    url:        "/wx/config_jssdk.json?url=" + escape(url),
    beforeSend: function(){},
    global:     false
})
.done(function(data){
  wx.config({
      appId:     data.appId,
      timestamp: data.timestamp,
      nonceStr:  data.nonceStr,
      signature: data.signature,
      jsApiList: data.jsApiList
  });

  wx.ready(function(){
    console.log('wx.config is ready, checking js api available');
    wx.checkJsApi({
       jsApiList: data.jsApiList,
       success: function (res) {
         console.log(JSON.stringify(res));
       }
     });
  });

  wx.error(function(e){
    console.log('wx.config is error');
    console.log(e.errMsg);
  })
})
