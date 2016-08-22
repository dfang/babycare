class CreateSmsHistories < ActiveRecord::Migration
  def change
    create_table :sms_histories do |t|
      t.integer :sender_user_id
      t.string :sender_phone
      t.integer :sendee_user_id
      t.string :sendee_phone
      t.references :reservation, index: true, foreign_key: true
      t.string :reservation_state_when_sms

      t.timestamps null: false
    end
  end
end
