class AddAasmStateToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :aasm_state, :string
  end
end
