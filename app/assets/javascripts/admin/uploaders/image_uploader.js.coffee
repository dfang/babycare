class @ImageUploader
  constructor: (opts) ->
    uploader = new plupload.Uploader
      runtimes        : 'html5, flash'
      browse_button   : opts.button
      max_file_size   : '10mb'
      url             : opts.url
      flash_swf_url   : '/uploader.swf'
      filters         : [
        { title : "图片文件", extensions : "jpg,jpeg,gif,png,bmp" }
      ]
      file_data_name  : 'image'
      multipart       : true
      multipart_params:
        authenticity_token: $('meta[name="csrf-token"]').attr('content')

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      console.log('upload start ....')
      uploader.start()

    uploader.bind "BeforeUpload", (up, file) ->
      holder = $("##{opts.button}").parent('.fields').attr('id', Math.floor(Math.random()*100000+1))
      uploader.settings.multipart_params =
        file_id: file.id
        target: opts.button
        page: $("##{opts.button}").parents('.upload').data('target')
        authenticity_token: $('meta[name="csrf-token"]').attr('content')
        holderId: $("##{opts.button}").parent('.fields').attr('id')

    uploader.bind 'Error', (up, err) ->
      up.refresh()

    uploader.bind 'UploadProgress', (up, file) ->
      text = file.percent + '%'

    uploader.bind 'FileUploaded', (up, file, data) ->
      eval(data.response)
      console.log(up)
      console.log(file)
      console.log(data)

    uploader.bind 'UploadComplete', (up, files) ->
      