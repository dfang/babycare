class Doctors::PatientsController < InheritedResources::Base
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user'
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :check_is_verified_doctor
  custom_actions :resource => [ :profile ]

  def profile
  end

  private

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to doctors_status_path and return
    end
  end

end
