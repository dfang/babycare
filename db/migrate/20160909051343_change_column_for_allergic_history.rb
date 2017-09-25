class ChangeColumnForAllergicHistory < ActiveRecord::Migration[5.1]
  def change
    change_column(:medical_records, :allergic_history, :text)
  end
end
