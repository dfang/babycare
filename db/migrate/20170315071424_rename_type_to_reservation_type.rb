class RenameTypeToReservationType < ActiveRecord::Migration
  def change
    rename_column :reservations, :type, :reservation_type
  end
end
