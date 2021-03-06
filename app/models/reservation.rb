# frozen_string_literal: true

class Reservation < OdooRecord
  self.table_name = 'fa_reservation'

  include ::StateMachine::Reservation
  extend Enumerize
  extend ActiveModel::Naming

  # Column name 'type' is restricted in ActiveRecord. try renaming the column name to something else or if you can't try this:
  # type is restricted word, you can't use it as a column name in ActiveRecord models (unless you're doing STI).
  # otherwise raise this error: The single-table inheritance mechanism failed to locate the subclass
  self.inheritance_column = :_type_disabled

  has_many :ratings, dependent: :destroy
  has_one :medical_record, dependent: :destroy
  has_many :phone_call_histories, dependent: :destroy
  has_many :sms_histories, dependent: :destroy
  has_many :reservation_examinations, foreign_key: :reservation_id, dependent: :destroy
  has_many :reservation_images, class_name: 'ReservationImage', dependent: :destroy
  accepts_nested_attributes_for :reservation_images
  accepts_nested_attributes_for :reservation_examinations

  belongs_to :doctor, optional: true
  # belongs_to :assistant, optional: true
  belongs_to :user
  belongs_to :family_member, foreign_key: :family_member_id, class_name: :User

  validates :p_phone, format: /(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/
  validates :chief_complains, presence: true

  attr_accessor :total_fee

  enumerize :aasm_state, in: %i[to_prepay prepaid to_examine to_consult consulting to_pay paid cancelled], default: :to_prepay, predicates: false
  # enumerize :reservation_type, in: %i[online offline], default: :offline, predicates: true

  delegate :hospital, to: :doctor, allow_nil: true
  delegate :name, to: :patient_user, prefix: :patient_user, allow_nil: true
  delegate :name, to: :doctor_user, prefix: :doctor_user, allow_nil: true

  # aasm guards
  def can_be_reserved?
    # self.user_b.present? && self.reservation_location.present? && self.reservation_time.present? && self.reservation_phone.present?
    # must be prepaid
    true
  end

  def marked_phone_number
    # http://stackoverflow.com/questions/26103394/regular-expression-to-mask-all-but-the-last-4-digits-of-a-social-security-number
    # Simply extract the last four characters and append them to a string of five '*'
    return '*' * 7 + p_phone[-4..-1] if p_phone.present?
  end

  def rating_by_doctor
    ratings.find_by(rated_by: doctor_id)
  end

  def rating_by_patient
    ratings.find_by(rated_by: user_id)
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
    User.find_by(id: user_id)
  end

  def doctor_user
    # doctor.user
    User.find_by(id: doctor.user_id)
  end

  def patient_user_phone
    p_phone || patient_user.mobile_phone
  end

  def doctor_user_phone
    doctor_user.try(:mobile_phone)
  end

  def reservation_title
    "#{name}的#{gender}"
  end

  def all_examination_uploaded_images?
    flag = true
    reservation_examinations.each do |re|
      flag = false if re.reservation_examination_images.count <= 0
    end
    flag
  end
end
