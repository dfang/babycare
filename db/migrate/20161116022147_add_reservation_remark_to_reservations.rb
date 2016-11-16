class AddReservationRemarkToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :reservation_remark, :text
  end
end
