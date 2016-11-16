class ChangeRemarkToChiefComplaintForReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :remark, :chief_complaints
  end
end
