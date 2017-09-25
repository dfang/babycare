class ChangeColumnForPeople < ActiveRecord::Migration[5.1]
  def change
    rename_column :people, :area_id, :district_id
  end
end
