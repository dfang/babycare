class CreateReservationExaminationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_examination_images do |t|
      t.references :reservation_examination, foreign_key: true, index: { name: 'index_images_on_reservation_examination_id' }
      t.string :data
      t.string :media_id

      t.timestamps
    end
  end
end
