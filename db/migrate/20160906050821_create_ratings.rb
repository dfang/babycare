class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :stars
      t.text :body
      t.references :reservation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :rated_by

      t.timestamps null: false
    end
  end
end
