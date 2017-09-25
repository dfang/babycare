class CreateLaboratoryExaminationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :laboratory_examination_images do |t|
      t.references :medical_record, index: true, foreign_key: true
      t.string :data
      t.boolean :is_cover

      t.timestamps null: false
    end
  end
end
