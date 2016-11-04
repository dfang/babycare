class My::PatientsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }

  before_action :check_is_verified_doctor
  skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status, :profile ]

  def reservations
    @reservations = current_user.reservations
  end

  def index
  end

  def status
  end

  def profile
  end

  private

  def check_is_verified_doctor
    if current_user.is_verified_doctor?
      redirect_to my_patients_status_path and return
    end
  end
end
