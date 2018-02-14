$(document).on('click', '.weui-navbar__item', function (e) {
  $(this).addClass('weui-bar__item_on').siblings('.weui-bar__item_on').removeClass('weui-bar__item_on');

  index = $('.weui-navbar__item').index($(e.target));
  console.log(index);
  $('.tab-content').not('.tab'+ (index+1)).hide();
  $('.tab'+ (index+1)).show();
});


function isWeiXin(){
  var ua = window.navigator.userAgent.toLowerCase();
  return ua.match(/MicroMessenger/i) == 'micromessenger';
}

function isAndroid(){
  var ua = navigator.userAgent.toLowerCase();
  return ua.indexOf("android") > -1; //&& ua.indexOf("mobile");
}

var uploader =  (function() {

  function uploader(pickerId, uploadTarget, uploadUrl, uploadType, uploadPhotosField, notAutoStart){

    var webUploader;
    if(uploadType != 'multiple'){
      uploadType = 'single';
    }

    webUploader = new plupload.Uploader({
      runtimes        : 'html5, flash, html4',
      browse_button   : pickerId,
      max_file_size   : '10mb',
      url             : uploadUrl,
      flash_swf_url   : '/uploader.swf',
      filters         : [ { title : "图片文件", extensions : "jpg,jpeg,gif,png,bmp" } ],
      file_data_name  : 'file',
      multipart       : true,
      multi_selection : false,
      dragdrop        : false,
      max_retries     : 3,
      multipart_params: { authenticity_token: $('meta[name="csrf-token"]').attr('content') }
    });

    webUploader.init();

    webUploader.bind('init', function(up, files){
      console.log('init uploader');
    });

    webUploader.bind('browse', function(up, files){
      console.log('Browse');
    });

    webUploader.bind('FilesAdded', function(up, files){
      console.log('FilesAdded');
      // if(!notAutoStart){
        webUploader.start();
      // }
    });

    webUploader.bind("BeforeUpload", function(up, file){
      console.log('BeforeUpload');
      $button = $(up.settings.browse_button[0]);

      holder = $button.parent('.fields').attr('id', Math.floor(Math.random()*100000+1));
      webUploader.settings.multipart_params = {
        file_id: file.id,
        pickerId: pickerId,
        uploadTarget: uploadTarget,
        uploadType: uploadType,
        uploadPhotosField: uploadPhotosField, // 上传多张图片的时候用这个，特别是适合于一个模型有多个多张图片比如MedicalRecord 有 has_many laboratory_examination_images， imaging_examination_images
        page: $button.parents('.upload').data('target'),
        authenticity_token: $('meta[name="csrf-token"]').attr('content'),
        holderId: $button.parent('.fields').attr('id')
      };

      if(uploadType == 'multiple'){
        // console.log('uploading multiple images')
        // console.log('fuck')
        // console.log('you')

        if(!$(uploadTarget).find('.weui-uploader__file.holder').length > 0 ){
          console.log(' has not holder so append a holder ');
          $(uploadTarget).find('ul.weui-uploader__files').append('<li class="weui-uploader__file holder" style="background:rgba(74, 56, 66, 0.13)"></li>');
        }
      }

    });


    webUploader.bind('UploadFile', function(up, file){
      console.log('UploadFile');
    });

    webUploader.bind('UploadProgress', function(up, file){
      console.log('UploadProgress');
      text = file.percent + '%';
      console.log(up);
      console.log(file);
      $(uploadTarget).find('li.weui-uploader__file:last').addClass('weui-uploader__file_status').html('<div class="weui-uploader__file-content">' + file.percent  + '%</div>');
    });

    webUploader.bind('FileUploaded', function(up, file, data){
      // console.log('FileUploaded')
      eval(data.response);
      // console.log(up)
      // console.log(file)
      // console.log(data)
      $(uploadTarget).find('li.weui-uploader__file').removeClass('weui-uploader__file_status');
    });

    webUploader.bind('UploadComplete', function(up, files){
      // console.log('UploadComplete')
      up.destroy();
    });

    webUploader.bind('Error', function(up, err){
      alert('Error');
      up.refresh();
    });

    webUploader.bind('Destroy', function(up, file){
      // console.log('Destroy');
    });

    return webUploader;
  }
  return uploader;


  // $(document).on('click', '.weui-uploader__input-box', function(e){
  //   $(e.target).parent('.weui-uploader__bd').find('.moxie-shim input[type=file]').trigger('click')
  // })

  // window.ParsleyConfig = $.extend( true, {}, window.ParsleyConfig, {
  //   uiEnabled: true,
  //   errorsWrapper: ''
  // });

  // window.Parsley.on('field:error', function() {
  //   $(this.$element).parents('.weui-cell').addClass('validation_error')
  // })
  // .on('field:success', function() {
  //   $(this.$element).parents('.weui-cell').removeClass('validation_error')
  // })


}());
