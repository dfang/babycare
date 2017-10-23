class CreateReservationExaminations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_examinations do |t|
      t.references :reservation, foreign_key: true
      t.references :examination, foreign_key: true

      t.timestamps
    end
  end
end
