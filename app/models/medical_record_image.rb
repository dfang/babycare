class MedicalRecordImage < ActiveRecord::Base
  establish_connection "odoo_#{Rails.env}"
  self.table_name = 'fa_medical_record_image'

  include ImageVersion
  mount_image_version :data

  # mount_uploader :data, AdminImageUploader
  belongs_to :medical_record
end
