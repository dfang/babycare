class RenameChildGenderToGenderForReservations < ActiveRecord::Migration[5.1]
  def change
    rename_column :reservations, :child_gender, :gender
  end
end
