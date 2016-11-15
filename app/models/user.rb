class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include ImageVersion
  mount_image_version :avatar
  # mount_image_version :qrcode
  mount_uploader :qrcode, SingleUploader


  has_many :authentications, :dependent => :destroy
  has_one :doctor

  # has_many :reservations, :foreign_key => 'user_a'
  has_many :medical_records
  has_many :settings
  has_many :transactions
  has_one :wallet
  has_many :ratings, :dependent => :destroy

  def wechat_authentication
    wechat ||= authentications.where(provider: 'wechat').first
  end

  def self.create_wechat_user(wechat_session)
    Rails.logger.info "wechat_session:::: #{wechat_session}"
    wx_nickname = wechat_session.nickname
    nickname = wx_nickname.strip.size > 0 ? wx_nickname : User.gen_name

    users_count = User.where(name: nickname).count

    user = User.new
    user.name = "#{nickname}#{users_count.zero? ? '' : users_count}"
    user.email = "wx_user_#{SecureRandom.hex}@wx_email.com"
    p user.name

    user.gender = wechat_session.sex
    user.avatar = wechat_session.headimgurl
    # user.gen_slug
    Rails.logger.info "user::: #{user.inspect}"
    user.save(validate: false)
    return user
  end

  def reservations
    if self.is_verified_doctor?
      Reservation.where(user_b: self.id)
    else
      Reservation.where(user_a: self.id)
    end
  end

  def is_doctor?
    self.doctor.present?
  end

  def is_verified_doctor?
    is_doctor? && self.doctor.verified?
  end

  def self_reservations
    # if self.is_doctor?
    #   self.doctor.reservations
    # else
    #   self.reservations
    # end
  end


  def increase_income(amount, source, reservation_id)
    transactions.create({
      operation: "income",
      amount: amount,
      reservation_id: reservation_id,
      source: source
    })
  end

  def withdraw_cash(amount, withdraw_target)
    transactions.create({
      operation: "withdraw",
      amount: amount
    })
  end
end
