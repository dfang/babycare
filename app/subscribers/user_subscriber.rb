# frozen_string_literal: true

class UserSubscriber
  def create_user_successful(user)
    Rails.logger.info 'build wallet'

    user.create_wallet!

    # background job
    # user.save_qrcode!
  end
end
