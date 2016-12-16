class ChangeColumnTypesForMedicalRecords < ActiveRecord::Migration
  def change
    change_column(:medical_records, :chief_complaint, :text)
    change_column(:medical_records, :history_of_present_illness, :text)
    change_column(:medical_records, :past_medical_history, :text)
    change_column(:medical_records, :laboratory_and_supplementary_examinations, :text)
    change_column(:medical_records, :treatment_recommendation, :text)
    change_column(:medical_records, :preliminary_diagnosis, :text)
    change_column(:medical_records, :imaging_examination, :text)
    change_column(:medical_records, :remarks, :text)
  end
end
