class AddMediaIdToLaboratoryExaminationImages < ActiveRecord::Migration[5.1]
  def change
    add_column :laboratory_examination_images, :media_id, :integer
  end
end
