class RenameColumnForReservations < ActiveRecord::Migration[5.1]
  def change
    rename_column :reservations, :chief_complaints, :chief_complains
  end
end
