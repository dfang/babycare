class AddOutTradeNoToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :out_trade_no, :string
  end
end
