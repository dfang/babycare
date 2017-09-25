class AddUserIdToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :user, index: true, foreign_key: true
  end
end
