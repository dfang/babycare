class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user, foreign_key: true
      t.string :account_name
      t.integer :account_number
      t.string :bank_branch_name

      t.timestamps
    end
  end
end
