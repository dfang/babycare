class AddNestedToPerson < ActiveRecord::Migration
  def up

    add_column :people, :parent_id, :integer # Comment this line if your project already has this column
    # Category.where(parent_id: 0).update_all(parent_id: nil) # Uncomment this line if your project already has :parent_id
    add_column :people, :lft,       :integer
    add_column :people, :rgt,       :integer

    # optional fields
    add_column :people, :depth,          :integer
    add_column :people, :children_count, :integer

    # This is necessary to update :lft and :rgt columns
    Person.rebuild!

  end

  def self.down
    remove_column :people, :parent_id
    remove_column :people, :lft
    remove_column :people, :rgt

    # optional fields
    remove_column :people, :depth
    remove_column :people, :children_count
  end

end
