import $ from 'jquery';
import wx from 'wechat-jssdk-promise';

wx.ready( () => {

  console.log('document is ready');
  // console.log("isWeiXin: " + isWeiXin());
  // console.log("isAndroid: " + isAndroid());

  // wx js sdk 图片上传 即时预览
  $(document).on('click', '.picker', (e) => {
    // e.preventDefault();
    let $files = $(e.target).parents('.weui-uploader').find('.weui-uploader__files');
    // let localIds = []

    wx.chooseImageAsync({
  		count:  9,
      sizeType:   ['original', 'compressed'],
      sourceType: ['album', 'camera']
    }).then( (res) => {
      let serverIds = []
      let localIds = res.localIds;
      let localIdsToPreview = res.localIds;
      console.log('choosed ' + localIdsToPreview.length + ' images');

        for (let i = 0, len = localIdsToPreview.length; i < len; i++) {
            preview($files, localIdsToPreview[i]);
        }

      syncUpload(localIds, serverIds)
    })

    const preview = ($files, localId) => {
      wx.getLocalImgDataAsync({
        localId: localId
      }).then( (res) => {
          let localData = res.localData;
          let $li = $('<li class="weui-uploader__file">');
          let $gallery = $('<div class="weui-gallery" style="display: none;">');
          let $galleryImg = $('<span class="weui-gallery__img">');
          let $galleryOpr = $('<div class="weui-gallery__opr"><i class="weui-icon-delete weui-icon_gallery-delete"></i></div>')
          $li.css("background-image", "url(" + localData + ")");
          $galleryImg.css("background-image", "url(" + localData + ")");
          // $files.append($li);
          $files.parents('.weui-uploader').find('.weui-uploader__files').append($li);
          $li.append($gallery);
          $gallery.append($galleryImg);
          $gallery.append($galleryOpr);
      })
    }

    const syncUpload = (localIds, serverIds) => {
      if (localIds.length > 0) {
        let localId = localIds.shift();
        wx.uploadImageAsync({
            localId: localId,
            isShowProgressTips: 1
        }).then( (res) => {
            console.log("serverId is : " + res.serverId);
            serverIds.push(res.serverId);
            syncUpload(localIds, serverIds);
        });
      } else {
          console.log('上传成功!');
          // write serverId to hidden fields
          // let $files = $('.picker').parents('.weui-uploader').find('ul.weui-uploader__files');
          // write($files, serverIds);
          // let $lis = $files.find('li.weui-uploader__file')
          let existings = $files.find('input:hidden').length;

          console.log('existings: ' + existings);
          // console.log('serverIds are: ') ;
          // console.log(serverIds);

          var pickerId = $files.next('.picker').attr('id')

          for (let i = 0, len = serverIds.length; i < len; i++) {
            console.log('input ' + i);
            console.log('serverIds are: ') ;
            console.log(serverIds);
            let mediaId_name = "reservation_examinations_attributes[" + pickerId + "][reservation_examination_images_attributes][" + (i + existings) + "][media_id]"
            console.log(mediaId_name);

            let mediaId_value =  serverIds[i]
            console.log(mediaId_value);

            let $input = $('<input type="hidden">').addClass('media-id').attr('name', mediaId_name).attr('value', mediaId_value);

            $files.append($input);
          }
      }
    }
  })

  // 单张图片的大图预览
  $(document).on('click', 'li', (e) => {
    let $gallery = $(e.target).children('.weui-gallery');
    $gallery.fadeIn(200);
  })

  $(document).on('click', 'span', (e) => {
    let $gallery = $(e.target).parents('.weui-gallery');
    $gallery.fadeOut(200);
  })

  // 从DOM中删除还未上传的图片，已经上传的图片通过ujs删除的
  $(document).on('click', '.weui-icon_gallery-delete', (e) => {
    alert('clicked')
    let $li = $(e.target).parents('li.weui-uploader__file')
    if($li.attr('id') == undefined){
      $li.remove();
      e.preventDefault();
    }
  })

})
