class AddChildGenderToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :child_gender, :string
  end
end
