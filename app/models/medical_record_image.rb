class MedicalRecordImage < ActiveRecord::Base
  # include ImageVersion
  # mount_image_version :data

  # mount_uploader :data, AdminImageUploader
  belongs_to :medical_record
end
