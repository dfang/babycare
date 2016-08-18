class AddOutTradeNoToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :out_trade_no, :string
  end
end
