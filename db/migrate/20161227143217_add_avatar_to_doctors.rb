class AddAvatarToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :avatar, :string
  end
end
