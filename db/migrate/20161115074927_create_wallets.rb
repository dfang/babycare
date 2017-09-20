class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.float :balance_withdrawable
      t.float :balance_unwithdrawable

      t.timestamps null: false
    end
  end
end
