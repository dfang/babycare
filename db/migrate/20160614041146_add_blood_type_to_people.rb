class AddBloodTypeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :blood_type, :string
  end
end
