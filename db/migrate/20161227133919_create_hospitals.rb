class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :nature
      t.string :type
      t.string :quality
      t.references :city, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
