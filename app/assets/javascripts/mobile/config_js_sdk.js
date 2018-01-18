// import $ from 'jquery';

function config_js_sdk($, location){
    const url = window.location.href.split("#")[0];
    $.ajax({
      url: "/wx/config_jssdk.json?url=" + escape(url),
      global: false
    }).done(function (data) {
      console.log(data)
      console.log("wx.config starts");
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

    })
}



// const config = (location) => {

      // try {
      //   wx.configAsync({
      //     appId: data.appId,
      //     timestamp: data.timestamp,
      //     nonceStr: data.nonceStr,
      //     signature: data.signature,
      //     jsApiList: data.jsApiList
      //   }).then(() => {
      //     console.log('config ready')
      //   });
      // } catch (e) {
      //   console.error(e.message);
      // }


    // })
// }

// export default config;


// export default function config(location) {
//   let url = location.href.split("#")[0];
//   $.ajax({
//     url: "/wx/config_jssdk.json?url=" + escape(url),
//     beforeSend: function () {},
//     global: false
//   }).done(function (data) {

//     console.log(data);

//     console.log(wx);

//     wx.configAsync({
//       appId: data.appId,
//       timestamp: data.timestamp,
//       nonceStr: data.nonceStr,
//       signature: data.signature,
//       jsApiList: data.jsApiList
//     }).then( () => {
//       console.log("wx.config is ready, checking js api available");
//       wx.checkJsApi({
//         jsApiList: data.jsApiList,
//         success: function(res) {
//           console.log(JSON.stringify(res));
//         }
//       });
//     })
//     // wx.ready(function () {
//     // });

//     // wx.error(function (e) {
//     // });
//   });

// }
