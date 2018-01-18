$('#container').on('click', '.weui-tabbar__item', function () {
    $(this).addClass('weui_bar_item__on').siblings('.weui_bar_item__on').removeClass('weui_bar_item__on');
});
