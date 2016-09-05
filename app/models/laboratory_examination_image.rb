class LaboratoryExaminationImage < ActiveRecord::Base
	include ImageVersion
	mount_image_version :data

  belongs_to :medical_record
end
