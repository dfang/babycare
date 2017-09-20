class AddMobilePhoneToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mobile_phone, :string
  end
end
