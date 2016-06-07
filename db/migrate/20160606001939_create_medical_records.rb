class CreateMedicalRecords < ActiveRecord::Migration
  def change
    create_table :medical_records do |t|
      t.references :person, index: true, foreign_key: true
      t.date :onset_date
      t.text :chief_complaint
      t.text :history_of_present_illness
      t.text :past_medical_history
      t.boolean :allergic_history
      t.text :personal_history
      t.text :family_history
      t.text :vaccination_history
      t.text :physical_examination
      t.text :laboratory_and_supplementary_examinations
      t.text :preliminary_diagnosis
      t.text :treatment_recommendation
      t.text :remarks

      t.timestamps null: false
    end
  end
end
