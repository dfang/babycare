$(document).on('click', '.weui-navbar__item', function(e) {
  $(this)
    .addClass('weui-bar__item_on')
    .siblings('.weui-bar__item_on')
    .removeClass('weui-bar__item_on');

  index = $('.weui-navbar__item').index($(e.target));
  console.log(index);
  $('.tab-content')
    .not('.tab' + (index + 1))
    .hide();
  $('.tab' + (index + 1)).show();
});

function isWeiXin() {
  var ua = window.navigator.userAgent.toLowerCase();
  return ua.match(/MicroMessenger/i) == 'micromessenger';
}

function isAndroid() {
  var ua = navigator.userAgent.toLowerCase();
  return ua.indexOf('android') > -1; //&& ua.indexOf("mobile");
}
