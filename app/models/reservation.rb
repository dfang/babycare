class Reservation < ActiveRecord::Base
  include AASM
  extend Enumerize
  extend ActiveModel::Naming

  has_many :ratings, :dependent => :destroy
  has_one :medical_record, :dependent => :destroy
  has_many :phone_call_histories, :dependent => :destroy
  has_many :sms_histories, :dependent => :destroy

  validates :reservation_phone, format: /(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/
  validates_presence_of :name, :remark

  aasm do
    state :pending, initial: true
    state :reserved, :prepaid, :diagnosed, :paid, :rated, :archived, :overdued, :cancelled

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

    event :cancel do
      transitions :from => [:reserved, :prepaid, :pending ], :to => :cancelled
    end

    event :overdue do
      transitions from: :reserved, to: :overdued
    end
  end

  enumerize :aasm_state, in: [:pending, :reserved, :prepaid, :diagnosed, :paid, :archived, :rated, :overdued, :cancelled], default: :pending, predicates: true

  GENDERS = %w(儿子 女儿).freeze

  # for testing, use claimed_by instead of res.reserve to debug in rails console
  def claimed_by(user_b, reservation_time, reservation_location, reservation_phone)
    self.user_b = user_b
    self.reserve do
      params = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
      SmsNotifyUserWhenReservedJob.perform_now(self.patient_user_phone, params)
    end
    self.reservation_time = reservation_time
    self.reservation_location = reservation_location
    self.reservation_phone = reservation_phone || doctor_user.mobile_phone
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
    doctor_has_rated? && patient_has_rated? && aasm_state == :rated
  end

  def patient_user
    patient_user ||= User.find_by(id: self.user_a)
  end

  def doctor_user
    doctor_user ||= User.find_by(id: self.user_b)
  end

  def patient_user_phone
    patient_user_phone ||= reservation_phone || patient_user.mobile_phone
  end

  def patient_user_name
    patient_user_name ||= name || patient_user.try(:name)
  end

  def doctor_user_name
    doctor_user_name ||=  doctor_user.try(:name)
  end

  def doctor_user_phone
    doctor_user_phone ||= doctor_user.try(:mobile_phone)
  end

  def reserved_location
    reservation_location || doctor_user.doctor.try(:hospital)
  end

  def reserved_time
    if reservation_time.present?
      reservation_time.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def doctor
    docotr ||= doctor_user.try(:doctor)
  end

  def hospital
    doctor.hospital
  end
end
