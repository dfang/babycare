class My::Doctors::ReservationsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ], :member => [ :claim ]

  def reservations
  end

  def index
    @reservations = current_user.reservations
  end

  def status
  end

	# 医生认领用户的预约
	def claim
    if request.put?
			resource.update(reservation_params)
      resource.user_b = current_user.id
      resource.reserve!

			# 发送短信， 记录短信
			# IM::Ronglian.send_templated_sms

      redirect_to my_doctors_reservation_path(resource) and return
    end
  end

	# 医生完成服务
	def complete
		resource.diagnose!
		redirect_to my_doctors_reservation_path(resource) and return
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
