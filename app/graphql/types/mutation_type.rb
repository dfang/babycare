# frozen_string_literal: true

MedicalRecordImageInputType = GraphQL::InputObjectType.define do
  name 'MedicalRecordImageInputType'
  description 'Properties for creating a MedicalRecord'

  argument :data, types.String do
    description "image data url"
  end

  argument :category, types.String do
    description "category of medical record images"
  end
end

MedicalRecordInputType = GraphQL::InputObjectType.define do
  name 'MedicalRecordInputType'
  description 'Properties for creating a MedicalRecord'

  argument :medical_record_images_attributes, types[MedicalRecordImageInputType] do
    description "medical record images"
  end
  # argument :laboratory_examination_images, types[LaboratoryExaminationImageInputType]

  argument :id, types.Int do
    description 'table column user_id'
  end

  argument :user_id, types.Int do
    description 'table column user_id'
  end

  argument :name, types.String do
    description 'table column name'
  end

  argument :reservation_id, types.String do
    description 'table column reservation_id'
  end

  argument :gender, types.String do
    description 'table column gender'
  end

  argument :identity_card, types.String do
    description 'table column identity_card'
  end

  argument :weight, types.String do
    description 'table column weight'
  end

  argument :height, types.String do
    description 'table column height'
  end

  argument :temperature, types.String do
    description 'table column temperature'
  end

  argument :chief_complaint, types.String do
    description 'table column chief_complaint'
  end

  argument :systolic_pressure, types.String do
    description 'table column systolic_pressure'
  end

  argument :pulse, types.String do
    description 'table column pulse'
  end

  argument :date_of_birth, types.String do
    description 'table column date_of_birth'
  end

  argument :blood_type, types.String do
    description 'table column blood_type'
  end

  argument :pain_score, types.String do
    description 'table column pain_score'
  end

  argument :bmi, types.String do
    description 'table column bmi'
  end

  argument :physical_examination, types.String do
    description 'table column physical_examination'
  end

  argument :oxygen_saturation, types.String do
    description 'table column oxygen_saturation'
  end

  argument :respiratory_rate, types.String do
    description 'table column respiratory_rate'
  end

  argument :diastolic_pressure, types.String do
    description 'table column diastolic_pressure'
  end

  argument :remarks, types.String do
    description 'table column remarks'
  end

  argument :personal_history, types.String do
    description 'table column personal_history'
  end

  argument :family_history, types.String do
    description 'table column family_history'
  end

  argument :vaccination_history, types.String do
    description 'table column vaccination_history'
  end

  argument :history_of_present_illness, types.String do
    description 'table column history_of_present_illness'
  end

  argument :past_medical_history, types.String do
    description 'table column past_medical_history'
  end

  argument :allergic_history, types.String do
    description 'table column allergic_history'
  end

  argument :preliminary_diagnosis, types.String do
    description 'table column preliminary_diagnosis'
  end

  argument :treatment_recommendation, types.String do
    description 'table column treatment_recommendation'
  end

  argument :imaging_examination, types.String do
    description 'table column imaging_examination'
  end

  argument :laboratory_and_supplementary_examinations, types.String do
    description 'table column laboratory_and_supplementary_examinations'
  end

  argument :onset_date, types.String do
    description 'table column onset_date'
  end

  # attr :create_uid
  # attr :write_uid
  # attr :create_date
  # attr :write_date
end

MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createMedicalRecord, MedicalRecordType do
    description 'create medical record'
    argument :medical_record, MedicalRecordInputType

    resolve ->(t, args, c) {
      Rails.logger.info "args[:medical_record].to_h ----> "
      Rails.logger.info args[:medical_record].to_h
      mr = MedicalRecord.new(args[:medical_record].to_h)
      Rails.logger.info mr.valid?
      mr.save!
      Rails.logger.info mr
      mr
    }
  end

  field :updateMedicalRecord, MedicalRecordType do
    description 'update a medical record'
    argument :medical_record, MedicalRecordInputType

    resolve ->(t, args, c) {
      params = args[:medical_record].to_h
      Rails.logger.info params
      mr = MedicalRecord.find_by(id: params["id"])
      Rails.logger.info mr
      if mr.present?
        mr.medical_record_images.delete_all
        mr.update(params)
      end
      Rails.logger.info mr
      mr
    }
  end
end
