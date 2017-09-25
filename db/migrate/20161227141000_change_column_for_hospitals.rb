class ChangeColumnForHospitals < ActiveRecord::Migration[5.1]
  def change
    remove_column(:doctors, :hospital)
    add_column(:doctors, :hospital_id, :integer)
  end
end
