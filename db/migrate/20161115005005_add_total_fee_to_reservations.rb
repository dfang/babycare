class AddTotalFeeToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :total_fee, :float
  end
end
