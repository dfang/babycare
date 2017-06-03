class AddBirthdayAndGenderToMedicalRecords < ActiveRecord::Migration
  def change
    add_column :reservations, :gender, :boolean
    add_column :reservations, :birthdate, :date
  end
end
