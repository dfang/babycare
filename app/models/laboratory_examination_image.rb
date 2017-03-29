class LaboratoryExaminationImage < ActiveRecord::Base
  establish_connection "odoo_#{Rails.env}"
  self.table_name = 'fa_laboratory_examination_image'

	include ImageVersion
	mount_image_version :data

  belongs_to :medical_record
end
