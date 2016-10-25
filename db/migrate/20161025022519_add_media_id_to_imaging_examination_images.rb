class AddMediaIdToImagingExaminationImages < ActiveRecord::Migration
  def change
    add_column :imaging_examination_images, :media_id, :integer
  end
end
