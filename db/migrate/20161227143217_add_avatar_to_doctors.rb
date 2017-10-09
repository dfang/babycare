class AddAvatarToDoctors < ActiveRecord::Migration[5.1]
  def change
    add_column :doctors, :avatar, :string
  end
end
