class BackgroundJobsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json, :js

  def call
    puts params

    @reservation = Reservation.find_by_id(params[:reservation_id])
    @reservation.user_b = current_user.doctor.id
    @reservation.save!

    IM::Ronglian.call(params["caller"], params["callee"], params["reservation_id"])
  end


  def send_sms

  end

end
