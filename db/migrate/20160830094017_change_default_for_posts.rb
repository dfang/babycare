class ChangeDefaultForPosts < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:posts, :published, false)
  end
end
