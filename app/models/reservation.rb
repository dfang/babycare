class Reservation < ActiveRecord::Base
  include AASM
  extend Enumerize
  extend ActiveModel::Naming

  has_many :ratings, :dependent => :destroy
  has_one :medical_record, :dependent => :destroy
  has_many :phone_call_histories, :dependent => :destroy
  has_many :sms_histories, :dependent => :destroy

  validates :mobile_phone, format: /(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/
  validates_presence_of :name, :remark

  # delegate :doctor, to: :doctor_user

  aasm do
    state :pending, initial: true
    state :reserved, :prepaid, :diagnosed, :paid, :rated, :archived

    event :reserve do
      transitions from: :pending, to: :reserved
    end

    event :prepay do
      transitions from: :reserved, to: :prepaid
    end

    event :diagnose do
      transitions from: :prepaid, to: :diagnosed
    end

    event :pay do
      transitions from: :diagnosed, to: :paid
    end

    event :unreserve do
      transitions from: :reserved, to: :pending
    end

    event :archive do
      transitions from: [:pending, :reserved], to: :archived
    end

    event :rate do
      transitions from: :paid, to: :rated
    end
  end

  enumerize :aasm_state, in: [:pending, :reserved, :prepaid, :diagnosed, :paid, :archived, :rated], default: :pending, predicates: true

  GENDERS = %w(儿子 女儿).freeze

  # use claimed_by instead of res.reserve to debug in rails console
  def claimed_by(user_b)
    self.user_b = user_b
    self.reserve
    self.save!
  end

  def marked_phone_number
    # http://stackoverflow.com/questions/26103394/regular-expression-to-mask-all-but-the-last-4-digits-of-a-social-security-number
    # Simply extract the last four characters and append them to a string of five '*'
    if mobile_phone.present?
      '*' * 7 + mobile_phone[-4..-1]
    end
  end

  def rating_by_doctor
    self.ratings.where(rated_by: self.user_b).first
  end

  def rating_by_patient
    self.ratings.where(rated_by: self.user_a).first
  end

  def doctor_has_rated?
    rating_by_doctor.present?
  end

  def patient_has_rated?
    rating_by_patient.present?
  end

  def rated?
    doctor_has_rated? && patient_has_rated?
  end

  def patient_user
    patient_user ||= User.find_by(id: self.user_a)
  end

  def doctor_user
    doctor_user ||= User.find_by(id: self.user_b)
  end
end
