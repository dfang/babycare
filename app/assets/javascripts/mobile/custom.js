this.uploader = (function() {
  function uploader(pickerId, uploadTarget, uploadUrl, uploadType){

    var webUploader;
    if(uploadType != 'multiple'){
      uploadType = 'single'
    }

    webUploader = new plupload.Uploader({
      runtimes        : 'html5, flash, html4',
      browse_button   : pickerId,
      max_file_size   : '10mb',
      url             : uploadUrl,
      flash_swf_url   : '/uploader.swf',
      filters         : [
        { title : "图片文件", extensions : "jpg,jpeg,gif,png,bmp" }
      ],
      file_data_name  : 'file',
      multipart       : true,
      multi_selection: false,
      max_files: 1,
      dragdrop: false,
      max_retries: 3,
      multipart_params:{
        authenticity_token: $('meta[name="csrf-token"]').attr('content')
      }
    })

    webUploader.init()

    webUploader.bind('init', function(up, files){
      console.log('init uploader')
    })

    webUploader.bind('browse', function(up, files){
      console.log('Browse')
    })

    webUploader.bind('FilesAdded', function(up, files){
      console.log('FilesAdded')
      webUploader.start()
    })

    webUploader.bind("BeforeUpload", function(up, file){
      console.log('BeforeUpload')
      $button = $(up.settings.browse_button[0])

      holder = $button.parent('.fields').attr('id', Math.floor(Math.random()*100000+1))
      webUploader.settings.multipart_params = {
        file_id: file.id,
        uploadTarget: uploadTarget,
        page: $button.parents('.upload').data('target'),
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        holderId: $button.parent('.fields').attr('id')
      }
    })

    webUploader.bind('Error', function(up, err){
      up.refresh()
    })

    webUploader.bind('UploadProgress', function(up, file){
      text = file.percent + '%'
    })

    webUploader.bind('FileUploaded', function(up, file, data){
      eval(data.response)
      console.log(up)
      console.log(file)
      console.log(data)
    })

    webUploader.bind('UploadComplete', function(up, files){
      console.log('UploadComplete')
    })
  }
  return uploader;
})();



//
//   var webUploader = WebUploader.create({
//     // 选完文件后，是否自动上传。
//     auto: true,
//     // 开起分片上传。
//     chunked: true,
//     // swf文件路径
//     // swf: BASE_URL + '/js/Uploader.swf',
//     // 文件接收服务端。
//     // server: '/global_images',
//     sendAsBinary: true,
//     server: uploadUrl,
//     // 选择文件的按钮。可选。
//     // 内部根据当前运行是创建，可能是input元素，也可能是flash.
//     pick: pickerId,
//     // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
//     resize: false,
//     // 只允许选择图片文件。
//     formData: {
//       uploadTarget: uploadTarget,
//       uploadType: uploadType // upload single or multiple images
//     },
//     accept: {
//         title: 'Images',
//         extensions: 'gif,jpg,jpeg,bmp,png',
//         mimeTypes: 'image/*'
//     }
//   });
//
//   // 当有文件被添加进队列的时候
//   webUploader.on('fileQueued', function(file) {
//     console.log('file queued .....')
//   });
//
//
//   // uploader.on('beforeFileQueued', function(file) {
//   //   console.log('queueeeeeeeeeeee')
//   // })
//
//   webUploader.on('startUpload', function(file) {
//     alert('starttttttttttttt upload')
//   })
//
//
//   // 文件上传过程中创建进度条实时显示
//   webUploader.on('uploadProgress', function(file, percentage) {
//
//     $(pickerId).find('.webuploader-pick').text('上传中....');
//
//     // var $li = $('#' + file.id),
//     //   $percent = $li.find('.progress .progress-bar');
//     // // 避免重复创建
//     // if(!$percent.length) {
//     //   $percent = $('<div class="progress progress-striped active">' + '<div class="progress-bar" role="progressbar" style="width: 0%">' + '</div>' + '</div>').appendTo($li).find('.progress-bar');
//     // }
//     // $li.find('p.state').text('上传中');
//     // $percent.css('width', percentage * 100 + '%');
//
//   });
//
//   webUploader.on('uploadSuccess', function(file, response) {
//     console.log(response._raw)
//     eval(response._raw);
//     $(pickerId).find('.webuploader-pick').text('上传成功');
//   });
//
//   webUploader.on('uploadError', function(file) {
//     $(pickerId).find('.webuploader-pick').text('上传出错');
//   });
//
//   webUploader.on('uploadComplete', function(file) {
//     // $('#' + file.id).find('.progress').fadeOut();
//   });
//
//   return webUploader;
// }
