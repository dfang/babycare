class CreateSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :symptoms do |t|
      t.string :name
      t.string :detail

      t.timestamps null: false
    end
  end
end
