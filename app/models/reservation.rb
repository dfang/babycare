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

  # attr_accessor :total_fee

  aasm do
    state :pending, initial: true
    state :reserved, :prepaid, :diagnosed, :paid, :rated, :archived, :overdued, :cancelled

    event :reserve, after_transaction: :after_reserved! do
      transitions from: :pending, to: :reserved, :guard => :can_be_reserved?
    end

    event :prepay, after_transaction: :after_prepaid! do
      transitions from: :reserved, to: :prepaid
    end

    event :diagnose, after_transaction: :after_diagnosed! do
      transitions from: :prepaid, to: :diagnosed
    end

    event :pay, after_transaction: :after_paid! do
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
    if reservation_phone.present?
      '*' * 7 + reservation_phone[-4..-1]
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

  # aasm guards
  def can_be_reserved?
    self.user_b.present? && self.reservation_location.present? && self.reservation_time.present? && self.reservation_phone.present?
  end

  # aasm transaction callbacks
  def after_reserved!
    params = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
    SmsNotifyUserWhenReservedJob.perform_now(self.patient_user_phone, params)
  end

  def after_prepaid!
    # user prepay and send sms to notify doctor prepaid
    params1 = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
    params2 = [ self.patient_user_name, self.reserved_time, self.reserved_location]
    SmsNotifyUserWhenPrepaidJob.perform_now(self.patient_user_phone, params1)
    SmsNotifyDoctorWhenPrepaidJob.perform_now(self.doctor_user_phone, params2)
  end

  def after_diagnosed!
    SmsNotifyUserWhenDiagnosedJob.perform_now(self.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
  end

  def after_paid!
    params = [self.patient_user_name]
    SmsNotifyDoctorWhenPaidJob.perform_now(self.doctor_user_phone, params)

    # increase doctor's income
    amount = self.prepay_amount + self.pay_amount
    source = self.pay_amount == 0 ? :online_consult : :offline_consult

    # increase doctor's wallet unwithdrawable amount
    doctor_user.increase_income(amount, source, self.id)
  end

end
