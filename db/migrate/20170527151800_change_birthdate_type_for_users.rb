class ChangeBirthdateTypeForUsers < ActiveRecord::Migration[5.1]
  def change
    change_column(:users, :birthdate, :date)
  end
end
