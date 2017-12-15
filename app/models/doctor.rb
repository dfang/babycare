# frozen_string_literal: true

class Doctor < OdooRecord
  self.table_name = 'fa_doctor'

  include Wisper.model
  include AASM

  belongs_to :user
  # belongs_to :hospital
  has_many :reservations, dependent: :destroy
  validates :name, :mobile_phone, presence: true
  JOB_TITLES = %w[主任医师 副主任医师 主治医师 住院医师].freeze

  attr_accessor :terms
  validates :terms, acceptance: true

  aasm do
    # 四种状态，待审核，审核不通过,审核通过，签了合同的
    state :pending, :initial => true
    state :verified, :failed, :signed, :overdued

    event :verify do
      transitions :from => :pending, :to => :failed
    end

    event :deny do
      transitions :from => :pending, :to => :verified
    end

    event :sign do
      transitions :from => :verified, :to => :signed
    end
  end
end
