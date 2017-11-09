# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  extend Enumerize
  extend ActiveModel::Naming

  has_many :reservations
  # has_many :reservations, through: :family_member_id

  include ImageVersion
  mount_image_version :avatar
  # mount_image_version :qrcode

  mount_uploader :qrcode, SingleUploader

  include Wisper.model

  has_ancestry

  enumerize :gender, in: %i[male female], default: :male
  GENDERS = [%w[儿子 male], %w[女儿 female]].freeze

  validates :name, presence: true
  # validates :birthdate, presence: true

  with_options dependent: :destroy do |assoc|
    assoc.has_many :authentications
    assoc.has_one :doctor
    assoc.has_one :wallet
    assoc.has_many :medical_records
    assoc.has_many :transactions
    assoc.has_many :ratings
  end

  def wechat_authentication
    authentications.find_by(provider: 'wechat')
  end

  def self.create_wechat_user(wechat_session)
    Rails.logger.info "wechat_session:::: #{wechat_session}"
    wx_nickname = wechat_session.nickname
    nickname = !wx_nickname.strip.empty? ? wx_nickname : User.gen_name
    users_count = User.where(name: nickname).count

    user = User.new(
      name: "#{nickname}#{users_count.zero? ? '' : users_count}",
      email: "wx_user_#{SecureRandom.hex}@wx_email.com",
      gender: wechat_session.sex,
      avatar: wechat_session.headimgurl
    )
    # user.gen_slug
    Rails.logger.info "user::: #{user.inspect}"
    user.save(validate: false)
    user
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
    if wallet.balance_unwithdrawable >= amount
      wallet.balance_unwithdrawable -= amount
      wallet.save!
    end
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
    qrcode = RQRCode::QRCode.new("#{Settings.wx_qrcode.qrcode_url}/users/#{self.id}/scan_qrcode")
    png = qrcode.as_png(
                resize_gte_to: false,
                resize_exactly_to: false,
                fill: 'white',
                color: 'black',
                size: 180,
                border_modules: 4,
                module_px_size: 6,
                file: nil
              )
    image_path = "#{Rails.root.join('tmp',  "qrcode-#{self.id}.png")}"
    png.save(image_path)
    self.update_attribute(:qrcode, File.open(image_path))
    self.save!
  end

  private

  # method for testing
  def settle_all_transactions_right_now!
    transactions.pending.find_each(&:settle!)
  end
end
