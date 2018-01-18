坑系列


1. 微信 iOS版
chooseImage 之后要getLocalImageData 才能预览, 而安卓版localID直接就可以用img src预览  

2. 微信 iOS版
div 绑定点击事件 无法触发的
比如图片上传 <div class="weui-uploader__input-box" id='picker1' style="cursor:pointer">
要么加上style="cursor:pointer"
要么在css里加上
.weui-uploader__input-box {
  cursor: pointer;
}
或者绑定touchstart事件
$(document).on("click touchstart", "#div", function(){})  



