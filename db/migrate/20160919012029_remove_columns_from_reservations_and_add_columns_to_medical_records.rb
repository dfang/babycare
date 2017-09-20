class RemoveColumnsFromReservationsAndAddColumnsToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :reservations, :birthdate
    remove_column :reservations, :gender
    add_column :medical_records, :gender, :boolean
    add_column :medical_records, :birthdate, :date
  end
end
