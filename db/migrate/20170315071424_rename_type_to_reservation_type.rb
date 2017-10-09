class RenameTypeToReservationType < ActiveRecord::Migration[5.1]
  def change
    rename_column :reservations, :type, :reservation_type
  end
end
