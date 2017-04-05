class ProcessDoctorIdCardBackImageJob < ActiveJob::Base
  queue_as :urgent

  def perform(doctor)
    # 因为wx.chooseImage, wx.uploadImage 会把图片上传到微信的服务器，所以这里要从微信服务器下载了，然后存到自己的服务器
    url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{WxApp::WxCommon.get_access_token}&media_id=#{doctor.id_card_back_media_id}"
    global_image = GlobalImage.create(remote_data_url: url)
    # 把wx.uploadImage 生成的 media_id 置空
    # image.media_id = ""
    doctor.update_column(:id_card_back, global_image.data_url)
  end
end
