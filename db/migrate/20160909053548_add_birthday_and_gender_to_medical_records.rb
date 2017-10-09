class AddBirthdayAndGenderToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :gender, :boolean
    add_column :reservations, :birthdate, :date
  end
end
