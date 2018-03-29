class AddCategoryToMedicalRecordImages < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_record_images, :category, :string
  end
end
