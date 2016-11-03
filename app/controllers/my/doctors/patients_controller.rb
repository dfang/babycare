class My::Doctors::PatientsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_user
  before_action :check_is_verified_doctor

  def profile

  end

  private

  def find_user
    @user ||= User.find_by(id: params[:id])
  end

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end

end
