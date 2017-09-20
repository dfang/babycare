class AddReservationRemarkToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :reservation_remark, :text
  end
end
