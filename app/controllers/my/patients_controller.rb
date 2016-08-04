class My::PatientsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_is_verified_doctor
  skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ]

  def reservations
    @reservations = current_user.self_reservations
  end

  def index
  end

  def status
  end

  private

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to status_my_patients_path and return
    end
  end
end
