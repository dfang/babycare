/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker');

import $ from "jquery";

// 加上这两句会破坏mobile.js里的.tags() 和 .parsley()
// global.$ = $;
// global.jQuery = $;

import Turbolinks from "turbolinks";
import Rails from "rails-ujs";

import './vendor';
// import Parsley from "parsleyjs";
// require("parsleyjs");
import IM from './im';
window.IM = IM;

import './captcha';

// require('parsleyjs');

// console.log($.name);
Rails.start();
Turbolinks.start();

// $.fn.parsley = new Parsley.Factory();

$.ajaxSetup({
  beforeSend: function(jqXHR) {
    $("#loadingToast").fadeIn(100);
  },
  complete: function(jqXHR) {
    // setTimeout(function () {
    $("#loadingToast").hide(100);
    // }, 1200);
  }
});

$("docoment").on("click", "a.disabled, button.disabled", function(e){
  e.preventDefault();
  // return false;
});

$("#container").on("click", ".weui-tabbar__item", function() {
  $(this).addClass("weui_bar_item__on").siblings(".weui_bar_item__on").removeClass("weui_bar_item__on");
});

// $(document).on("turbolinks:load", function() {
  // new Parsley.Factory("form.has_validations");
// })
