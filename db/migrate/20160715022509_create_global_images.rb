class CreateGlobalImages < ActiveRecord::Migration
  def change
    create_table :global_images do |t|
      t.references :user, index: true, foreign_key: true
      t.string :data
      t.string :target_type

      t.timestamps null: false
    end
  end
end
