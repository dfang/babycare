class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :name
      t.string :mobile_phone
      t.string :remark
      t.string :location

      t.timestamps null: false
    end
  end
end
