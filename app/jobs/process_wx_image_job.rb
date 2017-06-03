# frozen_string_literal: true

# 处理多张的用ProcessWxImageJob, 目前用于病历中图片的上传
# 单张使用的是process_doctor_xxx_job.rb, 目前用于医生执照身份证的上传
class ProcessWxImageJob < ActiveJob::Base
  queue_as :urgent

  def perform(image)
    # media_id = "M4mYmHtMT5ngMuITmPEm8_OqxIHfzXJfbS3LmRsHNvrkaEhgPRxmypO5RZKdtkye"
    # 因为wx.chooseImage, wx.uploadImage 会把图片上传到微信的服务器，所以这里要从微信服务器下载了，然后存到自己的服务器
    url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{WxApp::WxCommon.get_access_token}&media_id=#{image.media_id}"
    global_image = GlobalImage.create(remote_data_url: url)
    # MedicalRecordImage.data = global_image.data
    # model_name.classify.constantize.send(:data, image.data)
    # image.data = global_image.data
    # image.save!

    # 经验: Job里最好用update_column 不触发ActiveRecord callback, 否则会引起observer的循环调用
    image.update_column(:data, global_image.data_url)
  end
end
