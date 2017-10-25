class Doctors::ExaminationsController < ApplicationController
  before_action -> { authenticate_user!(force: true) }

  def new
    @examination_groups = ExaminationGroup.all
    @reservation = Reservation.find_by(id: params[:reservation_id])
    @reservation_examination = ReservationExamination.new
    @reservation_examinations = @reservation.reservation_examinations
  end

  def create
    reservation_id = params["reservation_id"]
    ids = params["reservation_examination"]["examination_id"].delete_if {|x| x.blank?}
    ids.each do |examination_id|
      ReservationExamination.create(reservation_id: reservation_id, examination_id: examination_id)
    end

    redirect_to doctors_reservation_path(reservation_id) and return

  end

  def edit
    @reservation = Reservation.find_by(id: params[:reservation_id])
    @reservation_examination = ReservationExamination.first
    @reservation_examinations = @reservation.reservation_examinations

    @examination_groups = ExaminationGroup.all
  end

  def update
    reservation_id = params["reservation_id"]
    ids = params["reservation_examination"]["examination_id"].delete_if {|x| x.blank?}

    @reservation = Reservation.find_by(id: params[:reservation_id])
    @reservation.reservation_examinations.delete_all

    ids.each do |examination_id|
      ReservationExamination.create(reservation_id: reservation_id, examination_id: examination_id)
    end

    redirect_to doctors_reservation_path(reservation_id) and return
  end

  private

  def examination_params
  end
end
