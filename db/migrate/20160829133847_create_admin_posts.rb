class CreateAdminPosts < ActiveRecord::Migration
  def change
    create_table :admin_posts do |t|
      t.timestamps null: false
    end
  end
end
