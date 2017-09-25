class CreateSimpleCaptcha < ActiveRecord::Migration[5.1]
  def change
    create_table :simple_captchas do |t|
      t.string :key, :limit => 40
      t.string :value, :limit => 6
      t.timestamps null: false
    end
  end
end
