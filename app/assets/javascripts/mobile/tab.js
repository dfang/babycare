$('#container').on('click', '.weui_tabbar_item', function () {
    $(this).addClass('weui_bar_item_on').siblings('.weui_bar_item_on').removeClass('weui_bar_item_on');
});
