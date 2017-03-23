class RenameChildGenderToGenderForReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :child_gender, :gender
  end
end
