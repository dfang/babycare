class ChangeColumnTypeForReservations < ActiveRecord::Migration
  def change
    change_column :reservations, :total_fee, :integer
  end
end
