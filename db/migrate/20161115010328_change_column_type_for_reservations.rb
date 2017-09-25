class ChangeColumnTypeForReservations < ActiveRecord::Migration[5.1]
  def change
    change_column :reservations, :total_fee, :integer
  end
end
