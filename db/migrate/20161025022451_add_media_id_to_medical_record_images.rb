class AddMediaIdToMedicalRecordImages < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_record_images, :media_id, :integer
  end
end
