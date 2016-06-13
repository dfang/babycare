class AddColumnsToMedicalRecords < ActiveRecord::Migration
  def change
    add_column :medical_records, :imaging_examination, :text
  end
end
