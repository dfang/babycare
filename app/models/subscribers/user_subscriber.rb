class UserSubscriber
  def create_user_successful(user)
    user.build_wallet
    user.save!
  end
end
