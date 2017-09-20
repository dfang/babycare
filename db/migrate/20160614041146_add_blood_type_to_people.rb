class AddBloodTypeToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :blood_type, :string
  end
end
