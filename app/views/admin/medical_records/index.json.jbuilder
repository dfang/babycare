
# frozen_string_literal: true

json.array!(@admin_medical_records) do |admin_medical_record|
  json.extract! admin_medical_record, :id
  json.url admin_medical_record_url(admin_medical_record, format: :json)
end
