import $ from 'jquery';
import wx from 'wechat-jssdk-promise';

wx.ready( () => {

  $.ajax({
    url: '/patients/reservations/examinations_uploader.json?id=1',
    method: 'GET'
  }).then( (data)=> {
    console.log(data)
  })


  console.log('document is ready');
  // console.log("isWeiXin: " + isWeiXin());
  // console.log("isAndroid: " + isAndroid());

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
          $li.css("background-image", "url(" + localData + ")");
          // $files.append($li);
          $files.parents('.weui-uploader').find('.weui-uploader__files').append($li);
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
})
