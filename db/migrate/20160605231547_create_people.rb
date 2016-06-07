class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :mobile_phone
      t.string :birthdate
      t.string :gender
      t.string :email
      t.string :job
      t.string :employer
      t.string :nationality
      t.string :province_id
      t.string :city_id
      t.string :area_id
      t.string :address
      t.string :source
      t.string :wechat
      t.string :qq
      t.text :remark


      t.timestamps null: false
    end
  end
end
