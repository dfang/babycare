class AddQrcodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :qrcode, :string
  end
end
