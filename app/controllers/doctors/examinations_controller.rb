class Doctors::ExaminationsController < ApplicationController
  def new
    @examination_groups = ExaminationGroup.all
    @reservation_examination = ReservationExamination.new
    # @reservation = Reservation.find_by(id: params[:reservation_id])

    p @reservation

    # @reservation_examinations = @reservation.reservation_examinations.build()
  end

  def create
    # Rails.logger.info params[:examination_id]
    binding.pry

    reservation_id = params["reservation_id"]
    ids = params["reservation_examination"]["examination_id"].delete_if {|x| x.blank?}
    ids.each do |examination_id|
      ReservationExamination.create(reservation_id: reservation_id, examination_id: examination_id)
    end

    binding.pry

    redirect_to doctors_reservation_path(reservation_id) and return

  end

  private

  def examination_params
  end
end
