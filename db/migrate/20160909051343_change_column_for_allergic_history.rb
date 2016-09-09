class ChangeColumnForAllergicHistory < ActiveRecord::Migration
  def change
    change_column(:medical_records, :allergic_history, :text)
  end
end
