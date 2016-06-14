class ChangeColumnForPeople < ActiveRecord::Migration
  def change
    rename_column :people, :area_id, :district_id
  end
end
