class AddReservationUserAAndReservationUserBToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :user_a, :integer, references: 'users'
    add_column :reservations, :user_b, :integer, references: 'users'
  end
end
