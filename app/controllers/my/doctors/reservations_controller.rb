class My::Doctors::ReservationsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ]

  def reservations
  end

  def index
    @reservations = current_user.self_reservations
  end

  def status
  end

  private

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end
end
