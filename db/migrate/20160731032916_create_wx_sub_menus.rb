class CreateWxSubMenus < ActiveRecord::Migration
  def change
    create_table :wx_sub_menus do |t|
      t.references :wx_menu, index: true, foreign_key: true
      t.string :menu_type
      t.string :name
      t.string :key
      t.string :url
      t.integer :sequence

      t.timestamps null: false
    end
  end
end
