# frozen_string_literal: true

class Doctor < OdooRecord
  self.table_name = 'fa_doctor'

  include Wisper.model

  belongs_to :user
  # belongs_to :hospital
  has_many :reservations, dependent: :destroy
  validates :name, :mobile_phone, presence: true
  JOB_TITLES = %w[主任医师 副主任医师 主治医师 住院医师].freeze

  attr_accessor :terms
  validates :terms, acceptance: true

  scope :verified, -> { where(verified: true) }

  def verify
    update(:verified, true)
    broadcast(:doctor_verified_successful, self)
  end
end
