class AddPrepayFeeAndPayFeeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :prepay_fee, :integer
    add_column :reservations, :pay_fee, :integer
  end
end
