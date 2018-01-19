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

https://segmentfault.com/a/1190000011487764
https://www.google.com/search?client=safari&rls=en&q=iOS+%E5%BE%AE%E4%BF%A1+div+click&ie=UTF-8&oe=UTF-8


3. Rails.cache.fetch   
Ruby 里方法的返回值是最后一行的结果  
Rails.cache.fetch 如果有就返回，没有就计算block里的  
begin ... rescue ... end 也是返回最后一行的  

