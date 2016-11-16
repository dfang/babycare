class AddUserToWallets < ActiveRecord::Migration
  def change
    add_reference :wallets, :user, index: true, foreign_key: true
  end
end
