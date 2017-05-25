class My::Patients::FamilyMembersController < ApplicationController
  before_action -> { authenticate_user! }

  def index
    @members = current_user.children
  end

  def new
  end

  def create
    fake_email = "#{SecureRandom.hex}@a-fake-email.com"
    fake_password = "#{SecureRandom.hex}"
    user_params.merge!({
      email: fake_email, password: fake_password
    })
    current_user.children.create!(user_params)
  end

  def edit
  end

  def show
    @member = User.find(params[:id])
  end

  protected
  def user_params
    params.require(:user).permit(:name, :identity_card, :birthdate, :gender, :blood_type, :past_medical_history, :allergic_history, :personal_history, :family_history, :vaccination_history)
  end
end
