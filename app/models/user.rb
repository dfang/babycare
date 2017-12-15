# frozen_string_literal: true

class User < OdooRecord
  self.table_name = 'fa_user'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  extend Enumerize
  extend ActiveModel::Naming

  # has_many :reservations, through: :family_member_id
  # include ImageVersion
  # mount_image_version :avatar
  # mount_image_version :qrcode

  mount_uploader :qrcode, SingleUploader

  include Wisper.model

  has_ancestry

  enumerize :gender, in: %i[male female], default: :male
  GENDERS = [%w[儿子 male], %w[女儿 female]].freeze

  attr_accessor :terms
  validates :terms, acceptance: true
  validates :name, presence: true
  # validates :identity_card, presence: true
  # validates :birthdate, presence: true
  # validates :gender, presence: true
  # validates :allergic_history, presence: true
  # validates :vaccination_history, presence: true

  with_options dependent: :destroy do |assoc|
    assoc.has_many :authentications
    assoc.has_one :doctor
    assoc.has_one :wallet
    assoc.has_many :medical_records
    assoc.has_many :transactions
    assoc.has_many :ratings
    assoc.has_many :reservations
  end

  def reservations
    if verified_doctor?
      Reservation.where(doctor_id: id)
    else
      Reservation.where(user_id: id)
    end
  end

  def doctor?
    doctor.present?
  end

  def verified_doctor?
    doctor? && doctor.verified?
  end

  def patient?
    !verified_doctor?
  end

  def patient_and_has_children?
    patient? && children.any?
  end

  def patient_and_has_no_children?
    patient? && children.blank?
  end

  def self_reservations
    # if doctor?
    #   doctor.reservations
    # else
    #   reservations
    # end
  end

  def increase_income(amount, source, reservation_id)
    ActiveRecord::Base.transaction do
      transactions.create(operation: 'income',
                          amount: amount,
                          reservation_id: reservation_id,
                          source: source)
      increase_balance_unwithdrawable(amount)
    end
  end

  def withdraw_cash(amount, ip)
    transaction = Transaction.new
    ActiveRecord::Base.transaction do
      transaction = Transaction.create(operation: 'withdraw',
                                       amount: amount,
                                       withdraw_target: wechat_authentication.uid)

      decrease_balance_withdrawable(amount)

      # pay_to_wechat_user
      WxApp::WxJsSDK.pay_to_wechat_user(wechat_authentication.uid, amount, ip)
    end
    transaction
  end

  # 用户支付的时候
  # increase_balance_unwithdrawable

  # 结算transaction的时候
  # decrease_balance_unwithdrawable
  # increase_balance_withdrawable

  # 医生提现的时候
  # decrease_balance_withdrawable

  def increase_balance_unwithdrawable(amount)
    build_wallet if wallet.blank?
    wallet.balance_unwithdrawable += amount
    wallet.save!
  end

  def decrease_balance_unwithdrawable(amount)
    build_wallet if wallet.blank?
    return if wallet.balance_unwithdrawable < amount
    wallet.update(balance_unwithdrawable: wallet.balance_unwithdrawable - amount)
  end

  # 结算
  def decrease_balance_withdrawable(amount)
    build_wallet if wallet.blank?
    wallet.update(balance_withdrawable: balance_withdrawable - amount) if can_withdraw?(amount)
  end

  def increase_balance_withdrawable(amount)
    build_wallet if wallet.blank?
    wallet.balance_withdrawable += amount
    wallet.save!
  end

  def can_withdraw?(amount)
    wallet.balance_withdrawable >= amount
  end

  def profile_complete?
    name.present? && mobile_phone.present?
  end

  def save_qrcode!
    GenQrcodeForUserJob.perform_now(self)
  end

  def wechat_authentication
    authentications.find_by(provider: 'wechat')
  end

  def self.create_wechat_user(wechat_session)
    avatar = wechat_session.headimgurl
    avatar = '/none-avatar.png' if avatar == '/0'
    gender = if wechat_session.sex == 1
                "male"
             else
                "female"
             end
    User.create(
      name: wechat_session.nickname,
      email: "wx_user_#{SecureRandom.hex}@wx_email.com",
      gender: gender,
      avatar: avatar,
      password: SecureRandom.hex
    )
  end

  def create_wechat_authentication(authentication)
    authentications.create(authentication)
  end

  # TODO
  # FIXME
  def human_age
    if birthdate.nil?
      [0, 0, 0]
    else
      now = Time.zone.now
      days_in_last_month_of_birthdate = Time.days_in_month(birthdate.last_month.month, birthdate.last_month.year)
      days_of_age = now.day - birthdate.day + (now.day >= birthdate.day ? 0 : days_in_last_month_of_birthdate)
      months_of_age = now.month - birthdate.month + (now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day) ? 0 : 12) - (now.day >= birthdate.day ? 0 : 1)
      years_of_age = now.year - birthdate.year - (now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day) ? 0 : 1)
      [years_of_age, months_of_age, days_of_age]
    end
  end

  private

  # method for testing
  def settle_all_transactions_right_now!
    transactions.pending.find_each(&:settle!)
  end
end
