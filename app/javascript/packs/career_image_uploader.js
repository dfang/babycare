import $ from 'jquery';
import wx from 'wechat-jssdk-promise';
import util from './util.js';

wx.ready( () => {

  console.log('document is ready');
  // console.log("isWeiXin: " + isWeiXin());
  // console.log("isAndroid: " + isAndroid());
  // alert(util.isAndroid());
  $(document).on("ready", function(){

    console.log("isisWeiXin: " + isWeiXin())
    console.log("isAndroid: " + isAndroid())

    if( true ){
      // z-index可以遮住plupload生成的上传按钮, iOS的plupload选择框有拍照功能，所以用plupload
      // android 用 wx js sdk, 设置z-index 把plupload上传按钮遮住
      $(".weui-uploader__input-box").attr('z-index', 9999)

      url = location.href.split('#')[0]
      $.ajax({
        url:        "/wx/config_jssdk.json?url=" + escape(url),
        beforeSend: function(){},
        global:     false
      })
      .done(function(data){

        wx.config({
          appId:     data.appId,
          timestamp: data.timestamp,
          nonceStr:  data.nonceStr,
          signature: data.signature,
          jsApiList: data.jsApiList
        });

        wx.ready(function(){
          console.log('wx.config is ready, checking js api available');
          wx.checkJsApi({
             jsApiList: data.jsApiList,
             success: function (res) {
               console.log(JSON.stringify(res));
             }
           });
        });

        wx.error(function(e){
          console.log('wx.config is error');
          console.log(e.errMsg);
        })
      })

      $(document).on('click', '#picker1, #picker2, #picker3, #picker4', function(e){

        function uploadPhotosField(){
          uploadField = ""
          switch ($(e.target).attr('id')) {
            case 'picker1':
              uploadField = "doctor[id_card_front_media_id]"
              break;
            case 'picker2':
              uploadField = "doctor[id_card_back_media_id]"
              break;
            case 'picker3':
              uploadField = "doctor[license_front_media_id]"
              break;
            default:
              uploadField = "doctor[license_back_media_id]"
              break;
          }
          return uploadField
        }


        var localIds;
        wx.chooseImage({
            count:      1,
            sizeType:   ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
            sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
            success: function (res) {
                localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片

                for (var i = 0; i < localIds.length; i++) {
                  $files = $(e.target).parents('.weui-uploader').find('.weui-uploader__files')
                  // $files.find('.weui-uploader__file.holder').remove()
                  $files.empty()
                  $li = $('<li class="weui-uploader__file">').css("background-image", "url(" + localIds[i] + ")")
                  $i = $('<i class="weui-icon-delete weui-icon_gallery-delete"></i>').css("float", "right").css("margin-top", "2px")
                  $li.append($i)
                  $files.append($li)

                  wx.uploadImage({
                    localId: localIds[i].toString(),
                    isShowProgressTips: 1,
                    success: function(res) {
                      // alert('upload complete, serverId is ')
                      // alert(res.serverId)

                      $input = $('<input type="hidden">').attr("name", uploadPhotosField).attr('value', res.serverId)
                      $li.append($input)

                      // alert('input field name is')
                      // alert($li.find('input').attr('name'))
                      // alert('input field value is')
                      // alert($li.find('input').attr('value'))
                      // alert('images length is')
                      // alert($files.find('li input').length);
                    },
                    fail: function(res) {
                      alert(JSON.stringify(res));
                    }
                  })

                }
            }
        });
      })

    }else{

      uploader1 = new uploader( 'picker1', '.weui_uploader1', '/global_images.js', 'single')
      uploader2 = new uploader( 'picker2', '.weui_uploader2', '/global_images.js', 'single')
      uploader3 = new uploader( 'picker3', '.weui_uploader3', '/global_images.js', 'single')
      uploader3 = new uploader( 'picker4', '.weui_uploader4', '/global_images.js', 'single')

      // delegate click weui upload icon to uploader
      $(document).on('click', '.weui-uploader__input-box', function(e){
        $(e.target).parent('.weui-uploader__bd').find('.moxie-shim input[type=file]').trigger('click')
      })

    }

    // 删除图片按钮
    $(document).on('click', '.weui-icon-delete', function(e){
      $(e.target).parents('li').remove()
    })

  })
})
