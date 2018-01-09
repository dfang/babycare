class AddForiegnKeyToBankAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_accounts, :contract_id, :integer
  end
end
