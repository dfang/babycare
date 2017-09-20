class ChangeColumnsType < ActiveRecord::Migration[5.1]
  def change
    change_column(:medical_record_images, :media_id, :string)
    change_column(:laboratory_examination_images, :media_id, :string)
    change_column(:imaging_examination_images, :media_id, :string)
  end
end
