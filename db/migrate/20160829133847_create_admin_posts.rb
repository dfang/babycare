class CreateAdminPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_posts do |t|
      t.timestamps null: false
    end
  end
end
