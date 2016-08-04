class ReservationsController < InheritedResources::Base
  before_action :authenticate_user!

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_a = current_user.id
    create! {
      status_reservation_path(resource)
    }
  end

  def public
    @is_doctor = current_user.doctor.present?
    @reservations = Reservation.pending
  end

  def claim
    if request.get?
      @reservation = Reservation.find(params[:id])
    else
      @reservation = Reservation.find(params[:id])
      @reservation.update(reservation_params)
      @reservation.user_b = current_user.doctor.id
      @reservation.reserve!

      redirect_to status_reservation_path and return
    end
  end

  def status
  end

  private

  def reservation_params
    params.require(:reservation).permit!
  end

end
