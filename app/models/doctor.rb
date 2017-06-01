class Doctor < ApplicationRecord
  self.table_name = 'fa_doctor'
  include Wisper.model

  belongs_to :user
  # belongs_to :hospital
  has_many :reservations, through: :user
  validates :name, :mobile_phone, presence: true

  JOB_TITLES = [ "主任医师", "副主任医师", "主治医师", "住院医师" ]
  scope :verified, -> { where(verified: true) }

  def verify!
    update_attribute(:verified, true)
    broadcast(:doctor_verified_successful, self)
  end
end
