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

  GENDERS = [['男', false], ['女', true]].freeze
	TEMPERATURES = %w(37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42).map {|x| x.to_f }.freeze
  HEIGHTS = (50..120).to_a.freeze
  WEIGHTS = (5.0..10).step(0.1).map { |x| x.round(2) }.freeze
  PULSES = (15..45).to_a.freeze
  RESPIRATORY_RATES = (60..120).to_a.freeze
  BLOOD_PRESSURES =  (30..190).to_a.freeze
  OXYGEN_SATURATIONS = (1..100).to_a.freeze
  BMI = (15..35).to_a.map {|x| x.to_f }.freeze
  PAIN_SCORES = (0..10).to_a.freeze


end
