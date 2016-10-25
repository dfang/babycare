class AddMediaIdToMedicalRecordImages < ActiveRecord::Migration
  def change
    add_column :medical_record_images, :media_id, :integer
  end
end
