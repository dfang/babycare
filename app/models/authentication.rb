# frozen_string_literal: true

class Authentication < OdooRecord
  self.table_name = 'fa_authentication'

  belongs_to :user
  validates :provider, :uid, presence: true

  def self.create_from_omniauth_hash(omniauth, user_id)
    Authentication.create(
      provider:     'wechat',
      user_id:      user_id,
      nickname:     omniauth.nickname,
      uid:          omniauth.openid,
      unionid:      omniauth.unionid
    )
  end
end
