class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string    :mobile_phone
      t.string    :blood_type
      t.datetime  :birthdate
      t.boolean   :gender
      t.text      :history_of_present_illness
      t.text      :past_medical_history
      t.text      :allergic_history
      t.text      :personal_history
      t.text      :family_history
      t.text      :vaccination_history

      t.references :user
      t.timestamps null: false
    end
  end
end
