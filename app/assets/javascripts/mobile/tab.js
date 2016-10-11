$('#container').on('click', '.weui-tabbar__item', function () {
    $(this).addClass('weui_bar_item_on').siblings('.weui_bar_item_on').removeClass('weui_bar_item_on');
});
