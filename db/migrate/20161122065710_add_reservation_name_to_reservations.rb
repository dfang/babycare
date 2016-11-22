class AddReservationNameToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :reservation_name, :string
  end
end
