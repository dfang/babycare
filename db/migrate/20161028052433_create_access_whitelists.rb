class CreateAccessWhitelists < ActiveRecord::Migration[5.1]
  def change
    create_table :access_whitelists do |t|
      t.string :uid
      t.string :nickname

      t.timestamps null: false
    end
  end
end
