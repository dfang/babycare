# frozen_string_literal: true

class Patients::FamilyMembersController < ApplicationController
  before_action -> { authenticate_user! }

  def index
    @members = current_user.children
  end

  def new; end

  def create
    fake_email = "#{SecureRandom.hex}@a-fake-email.com"
    fake_password = SecureRandom.hex.to_s
    create_user_params = user_params.merge!(email: fake_email, password: fake_password)
    child = current_user.children.create!(create_user_params)
    redirect_to(patients_family_members_path) && return if child.errors.empty?
  end

  def edit
    @member = User.find(params[:id])
  end

  def show
    @member = User.find(params[:id])
  end

  def update
    @member = User.find(params[:id])
    @member.update_without_password(user_params)
    if @member.errors.any?
      render :edit
    else
      redirect_to(patients_family_member_path(@member)) && return
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :identity_card, :birthdate, :gender, :blood_type, :past_medical_history, :allergic_history, :personal_history, :family_history, :vaccination_history)
  end
end
