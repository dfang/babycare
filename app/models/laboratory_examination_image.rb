class LaboratoryExaminationImage < Image
  establish_connection "odoo_#{Rails.env}"
  self.table_name = 'fa_laboratory_examination_image'

  # 现在用微信js sdk 上传图片, 这个模型直接存七牛地址
  # 见process_wx_image_job.rb
	# include ImageVersion
	# mount_image_version :data

  belongs_to :medical_record
end
