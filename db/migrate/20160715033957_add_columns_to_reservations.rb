class AddColumnsToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :reservation_time, :datetime
    add_column :reservations, :reservation_location, :string
    add_column :reservations, :reservation_phone, :string
  end
end
