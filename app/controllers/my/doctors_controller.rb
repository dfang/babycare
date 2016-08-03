class My::DoctorsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :verify_is_doctor, only: [ :reservations, :index ]
  # skip_before_action :verify_is_doctor, only: :status

  custom_actions :collection => [ :reservations, :status ]

  def reservations
    @reservations = current_user.doctor.reservations
  end

  def index
  end

  def status
  end

  private

  def verify_is_doctor
    unless current_user.is_verified_doctor?
      redirect_to status_my_doctors_path and return
    end
  end

end
