class AddUserToWallets < ActiveRecord::Migration[5.1]
  def change
    add_reference :wallets, :user, index: true, foreign_key: true
  end
end
