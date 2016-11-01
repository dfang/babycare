class AddBloodTypeToMedicalRecords < ActiveRecord::Migration
  def change
    add_column :medical_records, :blood_type, :string
  end
end
