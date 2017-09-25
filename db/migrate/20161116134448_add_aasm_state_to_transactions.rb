class AddAasmStateToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :aasm_state, :string
  end
end
