class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :nickname
      t.string :unionid

      t.timestamps null: false
    end
  end
end
