class ChangeColumnForHospitals < ActiveRecord::Migration
  def change
    remove_column(:doctors, :hospital)
    add_column(:doctors, :hospital_id, :integer)
  end
end
