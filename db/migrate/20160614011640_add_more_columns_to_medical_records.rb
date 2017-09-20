class AddMoreColumnsToMedicalRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_records, :height, :integer
    add_column :medical_records, :weight, :float
    add_column :medical_records, :bmi, :float
    add_column :medical_records, :temperature, :float
    add_column :medical_records, :pulse, :integer
    add_column :medical_records, :respiratory_rate, :integer
    add_column :medical_records, :blood_pressure, :integer
    add_column :medical_records, :oxygen_saturation, :string
    add_column :medical_records, :pain_score, :integer
  end
end
