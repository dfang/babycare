class ReservationsController < InheritedResources::Base
  before_action :authenticate_user!

  def public
    @is_doctor = current_user.doctor.present?

    @reservations = Reservation.pending
  end

  def claim
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def reservation_params
    params.require(:reservation).permit!
  end
end
