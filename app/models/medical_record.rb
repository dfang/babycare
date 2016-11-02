class MedicalRecord < ActiveRecord::Base
  belongs_to :user
	belongs_to :reservation

  has_many :medical_record_images, class_name: 'MedicalRecordImage', dependent: :destroy
  has_many :laboratory_examination_images, class_name: 'LaboratoryExaminationImage', dependent: :destroy
  has_many :imaging_examination_images, class_name: 'ImagingExaminationImage', dependent: :destroy

  accepts_nested_attributes_for :medical_record_images, allow_destroy: true
  accepts_nested_attributes_for :laboratory_examination_images, allow_destroy: true
  accepts_nested_attributes_for :imaging_examination_images, allow_destroy: true

  has_one :cover, class_name: 'MedicalRecordImage'
	GENDERS = %w(男 女).freeze
	TEMPERATURES = %w(37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42).freeze
  HEIGHTS = (50..120).to_a.freeze
  WEIGHTS = (5.0..10).step(0.1).map { |x| x.round(2) }.freeze
end
