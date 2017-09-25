class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :reservation_id
      t.float :amount
      t.string :source
      t.string :withdraw_target
      t.string :operation

      t.timestamps null: false
    end
  end
end
