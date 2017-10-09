class CreatePhoneCallHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :phone_call_histories do |t|
      t.integer :caller_user_id
      t.string :caller_phone
      t.integer :callee_user_id
      t.string :callee_phone
      t.references :reservation, index: true, foreign_key: true
      t.string :reservation_state_when_call

      t.timestamps null: false
    end
  end
end
