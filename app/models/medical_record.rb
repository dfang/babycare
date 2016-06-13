class MedicalRecord < ActiveRecord::Base
  belongs_to :person

  has_many :medical_record_images, class_name: 'MedicalRecordImage', dependent: :destroy
  has_many :laboratory_examination_images, class_name: 'LaboratoryExaminationImage', dependent: :destroy
  has_many :imaging_examination_images, class_name: 'ImagingExaminationImage', dependent: :destroy

  accepts_nested_attributes_for :medical_record_images, allow_destroy: true
  accepts_nested_attributes_for :laboratory_examination_images, allow_destroy: true
  accepts_nested_attributes_for :imaging_examination_images, allow_destroy: true
  
  has_one :cover, class_name: 'MedicalRecordImage'

end
