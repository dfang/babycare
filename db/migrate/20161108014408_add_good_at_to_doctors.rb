class AddGoodAtToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :good_at, :string
  end
end
