class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.integer :months
      t.references :user, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.string :type

      t.timestamps
    end
  end
end
