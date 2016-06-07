class @QiniuUploader
  constructor: (opts) ->
    uploader = new Qiniu.uploader
      runtimes: "html5,flash,html4" #上传模式,依次退化
      browse_button: opts.button #上传选择的点选按钮，**必需**
      uptoken_url: "/token/generate" #Ajax请求upToken的Url，**必需**（服务端提供）
      domain: "http://gart360-dev.qiniudn.com/" #bucket 域名，下载资源时用到，**必需**
      # container: "container" #上传区域DOM ID，默认是browser_button的父元素
      max_file_size: "500mb" #最大文件体积限制
      flash_swf_url: "/uploader.swf" #引入flash,相对路径
      filters         : [
          {title : "视频文件", extensions : "mp4"}
      ]
      file_data_name  : 'file'
      
      max_retries: 3 #上传失败最大重试次数
      dragdrop: true #开启可拖曳上传
      drop_element: "container" #拖曳上传区域元素的ID，拖曳文件或文件夹后可触发上传
      chunk_size: "4mb" #分块上传时，每片的体积
      auto_start: true #选择文件后自动上传，若关闭需要自己绑定事件触发上传
      init:

        #文件添加进队列后,处理相关的事情
        FilesAdded: (up, files) ->
          # plupload.each files, (file) ->
          #
          # return
          parent = $("##{opts.button}").parents('.upload')
          $('small', parent).html("<div class=\"uploading\"><span class=\"g-block\"><b>0%</b></span></div>")

          uploader.start()

        #每个文件上传前,处理相关的事情
        BeforeUpload: (up, file) ->
          $('#btn-pupload-video').attr('disabled', 'disabled')

        #每个文件上传时,处理相关的事情
        UploadProgress: (up, file) ->
          text = \
            if parseInt(file.percent) == 100
              '上传完毕'
            else
              "上传中, 目前进度" + file.percent + '%' + ", 请稍等...."
          $("##{opts.button}").parents('.upload').find('.uploading').find('.g-block b').html(text)

        #每个文件上传成功后,处理相关的事情
        FileUploaded: (up, file, info) ->
          domain = up.getOption('domain')
          res = jQuery.parseJSON(info)
          link = domain + res.key
          # console.log link
          $('.form-group.upload.video').find('input#episode_data').val(link)
        #上传出错时,处理相关的事情
        Error: (up, err, errTip) ->

        UploadComplete: ->
          $('#btn-pupload-video').attr('disabled', false)
