class RemoveVerifiedColumnFromDoctors < ActiveRecord::Migration[5.1]
  def change
    remove_column :doctors, :verified
  end
end
