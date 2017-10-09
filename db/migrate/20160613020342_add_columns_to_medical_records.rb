class AddColumnsToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_records, :imaging_examination, :text
  end
end
