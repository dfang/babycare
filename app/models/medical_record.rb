# frozen_string_literal: true

class MedicalRecord < OdooRecord
  self.table_name = 'fa_medical_record'

  belongs_to :user
  belongs_to :reservation, required: false

  with_options dependent: :destroy do |assoc|
    assoc.has_many :medical_record_images, class_name: 'MedicalRecordImage'
  #   assoc.has_many :medical_record_images, class_name: 'MedicalRecordImage', inverse_of: :meidcal_record
  #   assoc.has_many :laboratory_examination_images, class_name: 'LaboratoryExaminationImage'
  #   assoc.has_many :imaging_examination_images, class_name: 'ImagingExaminationImage'
  end

  accepts_nested_attributes_for :medical_record_images, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :laboratory_examination_images, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :imaging_examination_images, reject_if: :all_blank, allow_destroy: true

  GENDERS = [['男', :male], ['女', :female]].freeze
  TEMPERATURES = %w[37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42].map(&:to_f).freeze
  HEIGHTS = (50..120).to_a.freeze
  WEIGHTS = (5.0..180).step(0.1).map { |x| x.round(2) }.freeze
  PULSES = (15..45).to_a.freeze
  RESPIRATORY_RATES = (60..120).to_a.freeze
  BLOOD_PRESSURES =  (30..190).to_a.freeze
  OXYGEN_SATURATIONS = (1..100).to_a.freeze
  BMI = (15..35).to_a.map(&:to_f).freeze
  PAIN_SCORES = (0..10).to_a.freeze

  def medical_record_title
    if name.blank?
      "#{created_at.strftime('%Y-%m-%d')}的病历"
    else
      "#{name}的病历"
    end
  end

  def medical_record_images_categoryA
    medical_record_images.where(category: "病史")
  end

  def medical_record_images_categoryB
    medical_record_images.where(category: "检查")
  end

  def medical_record_images_categoryC
    medical_record_images.where(category: "诊断")
  end
end
