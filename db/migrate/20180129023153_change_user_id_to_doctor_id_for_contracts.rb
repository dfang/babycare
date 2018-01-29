class ChangeUserIdToDoctorIdForContracts < ActiveRecord::Migration[5.1]
  def change
    remove_column(:doctors, :user_id)
    add_reference :contracts, :doctor, index: true, foreign_key: true
  end
end
