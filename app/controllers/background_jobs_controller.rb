class BackgroundJobsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json, :js
	after_action :record_phone_call, only: :call

  def call
    @reservation = Reservation.find_by_id(params[:reservation_id])
    @reservation.user_b = current_user.doctor.id
    @reservation.save!

    IM::Ronglian.call(params["caller"], params["callee"], params["reservation_id"], params['reservation_phone'])
  end


  def send_sms

  end

	private

	def record_phone_call
		p "after phone call record it"
		# {"caller"=>"1", "callee"=>"3", "reservation_id"=>"11", "reservation_phone"=>"17762575774", "controller"=>"background_jobs", "action"=>"call", "format"=>"json"}

		caller = User.find_by(id: params["caller"])
		reservation = Reservation.find_by(id: params["reservation_id"])
		reservation_state_when_call = reservation.aasm_state.to_s

		PhoneCallHistory.create(
			caller_user_id: params["caller"],
			caller_phone: caller.doctor.try(:mobile_phone),
			callee_user_id: params["callee"],
			callee_phone: params["reservation_phone"],
			reservation_id: params["reservation_id"],
			reservation_state_when_call: reservation_state_when_call
		)
	end


end
