class AddFieldsToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :id_card_front_media_id, :string
    add_column :doctors, :id_card_back_media_id, :string
    add_column :doctors, :license_front_media_id, :string
    add_column :doctors, :license_back_media_id, :string
  end
end
