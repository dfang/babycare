class AddReservationIdToMedicalRecords < ActiveRecord::Migration
  def change
    add_reference :medical_records, :reservation, index: true, foreign_key: true
  end
end
