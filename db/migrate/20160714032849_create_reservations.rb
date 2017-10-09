class CreateReservations < ActiveRecord::Migration[5.1]
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
