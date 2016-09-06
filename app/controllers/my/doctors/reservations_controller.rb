class My::Doctors::ReservationsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ], :member => [ :claim ]

  def reservations
  end

  def index
    @reservations = current_user.self_reservations
  end

  def status
  end

	def claim
    if request.get?
      @reservation = Reservation.find(params[:id])
    else
      @reservation = Reservation.find(params[:id])

			@reservation.update(reservation_params)
      @reservation.user_b = current_user.doctor.id
      @reservation.reserve!

			# 发送短信， 记录短信
			# IM::Ronglian.send_templated_sms

      redirect_to status_reservation_path and return
    end
  end

  private

	def reservation_params
    params.require(:reservation).permit!
  end

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end
end
