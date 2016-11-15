class AddTotalFeeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :total_fee, :float
  end
end
