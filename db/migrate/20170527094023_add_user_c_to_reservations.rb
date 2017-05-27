class AddUserCToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :user_c, :integer
  end
end
