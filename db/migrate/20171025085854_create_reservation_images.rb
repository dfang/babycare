class CreateReservationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_images do |t|
      t.references :reservation, foreign_key: true
      t.string :data
      t.string :media_id

      t.timestamps
    end
  end
end
