class AddOutTradePrepayNoAndOutTradePayNoToReservations < ActiveRecord::Migration
  def change
		add_column :reservations, :out_trade_pay_no, :string
		add_column :reservations, :out_trade_prepay_no, :string
		remove_column :reservations, :out_trade_no
  end
end
