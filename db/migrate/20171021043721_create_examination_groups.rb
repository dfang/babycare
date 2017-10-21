class CreateExaminationGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :examination_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
