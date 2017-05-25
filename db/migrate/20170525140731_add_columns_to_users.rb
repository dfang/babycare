class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :identity_card, :string
    add_column :users, :birthdate, :datetime
    add_column :users, :blood_type, :string
    add_column :users, :history_of_present_illness, :text
    add_column :users, :past_medical_history, :text
    add_column :users, :allergic_history, :text
    add_column :users, :personal_history, :text
    add_column :users, :family_history, :text
    add_column :users, :vaccination_history, :text
  end
end
