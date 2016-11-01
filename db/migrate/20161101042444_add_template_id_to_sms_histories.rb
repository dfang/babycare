class AddTemplateIdToSmsHistories < ActiveRecord::Migration
  def change
    add_column :sms_histories, :template_id, :integer
  end
end
