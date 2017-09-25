class AddGoodAtToDoctors < ActiveRecord::Migration[5.1]
  def change
    add_column :doctors, :good_at, :string
  end
end
