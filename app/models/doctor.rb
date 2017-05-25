class Doctor < ActiveRecord::Base
  establish_connection("odoo_#{Rails.env}".to_sym)
  self.table_name = 'fa_doctor'

  belongs_to :user
  # belongs_to :hospital
  has_many :reservations, through: :user
  validates :name, :mobile_phone, presence: true

  JOB_TITLES = [ "主任医师", "副主任医师", "主治医师", "住院医师" ]
  scope :verified, -> { where(verified: true) }

  def confirm!
    self.verified = true
    self.save!
  end
end
