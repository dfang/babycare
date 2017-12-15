class AddAasmStateToDoctors < ActiveRecord::Migration[5.1]
  def change
    add_column :doctors, :aasm_state, :string
  end
end
