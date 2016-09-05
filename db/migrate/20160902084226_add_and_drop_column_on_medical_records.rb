class AddAndDropColumnOnMedicalRecords < ActiveRecord::Migration
  def change
		remove_column :medical_records, :person_id
		add_reference :medical_records, :user
  end
end
