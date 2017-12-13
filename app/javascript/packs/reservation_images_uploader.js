import $ from 'jquery';
import wx from 'wechat-jssdk-promise';
import util from './util';

wx.ready( () => {

  console.log('document is ready');
  // console.log("isWeiXin: " + isWeiXin());
  // console.log("isAndroid: " + isAndroid());

  $(document).on('click', '#picker1', (e) => {
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
      if (util.isAndroid()) {
        appendToPlaceholder(localId);
      } else {
        wx.getLocalImgDataAsync({
          localId: localId
        }).then((res) => {
          let localData = res.localData;
          appendToPlaceholder(localData);
        })
      }
    }

    const appendToPlaceholder = (img) => {
      let $li = $('<li class="weui-uploader__file">');
      let $gallery = $('<div class="weui-gallery" style="display: none;">');
      let $galleryImg = $('<span class="weui-gallery__img">');
      let $galleryOpr = $('<div class="weui-gallery__opr"><i class="weui-icon-delete weui-icon_gallery-delete"></i></div>')
      $li.css("background-image", "url(" + img + ")");
      $galleryImg.css("background-image", "url(" + img + ")");
      // $files.append($li);
      $files.parents('.weui-uploader').find('.weui-uploader__files').append($li);
      $li.append($gallery);
      $gallery.append($galleryImg);
      $gallery.append($galleryOpr);
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
          let $files = $('#picker1').parents('.weui-uploader').find('ul.weui-uploader__files');
          // write($files, serverIds);
          // let $lis = $files.find('li.weui-uploader__file')
          let existings = $files.find('input:hidden').length;

          console.log(existings);
          console.log('serverIds are: ') ;
          console.log(serverIds);

          for (let i = 0, len = serverIds.length; i < len; i++) {
            let mediaId_name = "reservation[reservation_images_attributes][" + (i + existings) + "][media_id]"
            console.log(mediaId_name);

            let mediaId_value =  serverIds[i]
            console.log(mediaId_value);

            let $input = $('<input type="hidden">').addClass('media-id').attr('name', mediaId_name).attr('value', mediaId_value);

            $files.append($input);
          }
      }

    }


    const write = ($files, serverIds) => {
      console.log('write funciton...');
      console.log($files);
      console.log(serverIds);

      let $lis = $files.find('li.weui-uploader__file')
      let existings = $lis.find('input:hidden').length;

      for (let i = 0, len = serverIds.length; i < len; i++) {
        let mediaId_name = "reservation[reservation_images_attributes][" + (i + existings) + "][media_id]"
        let mediaId_value =  serverIds[i]
        let $input = $('<input type="hidden">').attr('class', 'media-id').attr('name', mediaId).attr('value', mediaId_value)
        $files.append($input);
      }
    }


  })




})
