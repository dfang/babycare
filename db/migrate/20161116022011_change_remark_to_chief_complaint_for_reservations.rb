class ChangeRemarkToChiefComplaintForReservations < ActiveRecord::Migration[5.1]
  def change
    rename_column :reservations, :remark, :chief_complaints
  end
end
