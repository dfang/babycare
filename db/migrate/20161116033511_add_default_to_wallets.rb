class AddDefaultToWallets < ActiveRecord::Migration
  def change
    change_column_default(:wallets, :balance_withdrawable, 0)
    change_column_default(:wallets, :balance_unwithdrawable, 0)
  end
end
