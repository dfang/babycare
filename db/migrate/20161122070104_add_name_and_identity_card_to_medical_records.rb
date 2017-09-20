class AddNameAndIdentityCardToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_records, :name, :string
    add_column :medical_records, :identity_card, :string
  end
end
