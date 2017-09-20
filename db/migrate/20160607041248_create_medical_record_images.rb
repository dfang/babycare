class CreateMedicalRecordImages < ActiveRecord::Migration[5.1]
  def change
    create_table :medical_record_images do |t|
      t.references :medical_record, index: true, foreign_key: true
      t.string :data
      t.boolean :is_cover

      t.timestamps null: false
    end
  end
end
