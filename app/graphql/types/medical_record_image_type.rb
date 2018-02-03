# frozen_string_literal: true

MedicalRecordImageType = GraphQL::ObjectType.define do
  name 'MedicalRecordImageType'

  backed_by_model :MedicalRecordImage do
    attr :id
    attr :medical_record_id
    attr :data
    attr :category
  end
end
