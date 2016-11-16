class RenameColumnForReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :chief_complaints, :chief_complains
  end
end
