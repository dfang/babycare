# frozen_string_literal: true

class UserSubscriber
  class << self
    def create_user_successful(user)
      Rails.logger.info 'build wallet'

      user.create_wallet(balance_unwithdrawable: 0, balance_withdrawable: 0)

      # background job
      # user.save_qrcode!
    end
  end
end
