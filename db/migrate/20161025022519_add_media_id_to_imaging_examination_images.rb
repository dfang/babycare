class AddMediaIdToImagingExaminationImages < ActiveRecord::Migration[5.1]
  def change
    add_column :imaging_examination_images, :media_id, :integer
  end
end
