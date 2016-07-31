class ReservationsController < InheritedResources::Base
  before_action :authenticate_user!

  # def new
    # binding.pry
    # sign_out current_user
  # end

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

  def reservation_params
    params.require(:reservation).permit!
  end

  # def authenticate_user!
  #   binding.pry
  #   super
  # end
end
