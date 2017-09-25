class AddTypeToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :type, :string
  end
end
