class My::HomeController < InheritedResources::Base
  before_action -> { authenticate_user!( force: true ) }
  before_action :check_is_verified_doctor, only: [ :index ]


  def index
  end

  private

  def check_is_verified_doctor
    if current_user.is_verified_doctor?
      redirect_to my_doctor_root_path and return
    else
      redirect_to my_patient_root_path and return
    end
  end

end
