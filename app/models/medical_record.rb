class MedicalRecord < ActiveRecord::Base
  belongs_to :person

  has_many :images, class_name: 'MedicalRecordImage', dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  
  has_one :cover, class_name: 'MedicalRecordImage'

end
