class MedicalRecordObserver < ActiveRecord::Observer
  def after_save(medical_record)
    # url = "https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token=#{WxApp::WxCommon.get_access_token}&media_id=''";

  end
end
