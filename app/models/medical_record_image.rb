# frozen_string_literal: true

class MedicalRecordImage < OdooRecord
  self.table_name = 'fa_medical_record_image'

  include Wisper.model
  # 现在用微信js sdk 上传图片, 这个模型直接存七牛地址
  # 见process_wx_image_job.rb
  # include ImageVersion
  # mount_image_version :data

  # mount_uploader :data, AdminImageUploader

  validates :medical_record_id, presence: true, on: :update
  belongs_to :medical_record
  # belongs_to :medical_record, inverse_of: :medical_record_images
end
