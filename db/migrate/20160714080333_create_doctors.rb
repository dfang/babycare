class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.string :hospital
      t.string :location
      t.float :lat
      t.float :long
      t.boolean :verified
      t.date :date_of_birth
      t.string :mobile_phone
      t.text :remark
      t.string :id_card_num
      t.string :id_card_front
      t.string :id_card_back
      t.string :license_front
      t.string :license_back
      t.string :job_title
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
