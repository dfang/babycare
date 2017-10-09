class AddTemplateIdToSmsHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :sms_histories, :template_id, :integer
  end
end
