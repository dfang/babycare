class Doctors::BaseController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_is_verified_doctor


  protected

  def check_is_verified_doctor
    redirect_to(doctors_status_path) unless current_user.verified_doctor?
  end
end
