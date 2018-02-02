# frozen_string_literal: true

Types::MedicalRecordType = GraphQL::ObjectType.define do
  name 'MedicalRecord'

  backed_by_model :MedicalRecord do
    attr :id
    attr :user_id
    attr :reservation_id
    attr :name
    attr :gender
    attr :identity_card
    attr :weight
    attr :pulse
    attr :height
    attr :date_of_birth
    attr :chief_complaint

    attr :vaccination_history
    attr :personal_history
    attr :past_medical_history
    attr :allergic_history
    attr :family_history
    attr :history_of_present_illness

    attr :temperature
    attr :blood_type
    attr :pain_score
    attr :bmi
    attr :oxygen_saturation
    attr :respiratory_rate
    attr :systolic_pressure
    attr :diastolic_pressure
    attr :onset_date

    attr :imaging_examination
    attr :physical_examination
    attr :laboratory_and_supplementary_examinations

    attr :treatment_recommendation
    attr :preliminary_diagnosis
    attr :remarks

    attr :create_uid
    attr :write_uid
    attr :create_date
    attr :write_date

    # http://tech.eshaiju.in/blog/2017/06/09/dry-graphql-definitions-using-interfaces/
    attr :created_at
    attr :updated_at
    # interfaces [ActiveRecordTimestamp]

  end
end

# mutation createMR {
#   createFaMedicalRecord(input: {faMedicalRecord: {bmi: 12, painScore: 34}}) {
#     faMedicalRecord {
#       personalHistory
#       temperature
#       oxygenSaturation
#     }
#   }
# }

# query allMR {
#   allFaMedicalRecords {
#     edges {
#       node {
#         id
#         onsetDate
#         bmi
#       }
#     }
#   }
# }
