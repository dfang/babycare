class AddChildGenderToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :child_gender, :string
  end
end
