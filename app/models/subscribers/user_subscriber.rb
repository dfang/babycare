class UserSubscriber
  def create_user_successful(user)
    Rails.logger.info "build wallet"
    user.create_wallet!
  end
end