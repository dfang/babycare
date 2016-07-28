class ReservationsController < InheritedResources::Base
  before_action :authenticate_user!

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_a = current_user.id
    create!
  end

  def public
    @is_doctor = current_user.doctor.present?

    @reservations = Reservation.pending
  end

  def claim
    @reservation = Reservation.find(params[:id])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def reservation_params
    params.require(:reservation).permit!
  end
end
