class CreateExaminations < ActiveRecord::Migration[5.1]
  def change
    create_table :examinations do |t|
      t.string :name
      t.references :examination_group

      t.timestamps
    end
  end
end
