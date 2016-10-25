class AddMediaIdToLaboratoryExaminationImages < ActiveRecord::Migration
  def change
    add_column :laboratory_examination_images, :media_id, :integer
  end
end
