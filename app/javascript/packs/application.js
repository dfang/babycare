/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// console.log('Hello World from Webpacker/Yarn')


// import './config_js_sdk'
import wx from 'wechat-jssdk-promise';


// extends wx.getLocalImgData
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
