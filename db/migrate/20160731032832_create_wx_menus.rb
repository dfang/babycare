class CreateWxMenus < ActiveRecord::Migration
  def change
    create_table :wx_menus do |t|
      t.string :menu_type
      t.string :name
      t.string :key
      t.string :url
      t.integer :sequence

      t.timestamps null: false
    end
  end
end
