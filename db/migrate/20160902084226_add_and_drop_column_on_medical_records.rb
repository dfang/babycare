class AddAndDropColumnOnMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :medical_records, :person_id
    add_reference :medical_records, :user
  end
end
