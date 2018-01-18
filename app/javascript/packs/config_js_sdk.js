import $ from 'jquery';
import wx from 'wechat-jssdk-promise';

class jssdk {
  static config(location) {
    let url = location.href.split("#")[0];
    $.ajax({
      url: "/wx/config_jssdk.json?url=" + escape(url)
    }).done(function (data) {
      wx.config({
        appId: data.appId,
        timestamp: data.timestamp,
        nonceStr: data.nonceStr,
        signature: data.signature,
        jsApiList: data.jsApiList
      });

      wx.ready(function () {
        console.log("wx.config is ready, checking js api available");
        wx.checkJsApi({
          jsApiList: data.jsApiList,
          success: function (res) {
            console.log(JSON.stringify(res));
          }
        });
      });

      wx.error(function (e) {
        console.log("wx.config is error");
        console.log(e.errMsg);
      });
    });
  }
}

export default jssdk;
