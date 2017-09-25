class AddBloodTypeToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_records, :blood_type, :string
  end
end
