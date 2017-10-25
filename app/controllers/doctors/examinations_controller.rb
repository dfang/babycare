class Doctors::ExaminationsController < ApplicationController
  before_action -> { authenticate_user!(force: true) }

  before_action :find_reservation , only: [:new, :edit]
  before_action :prepare_checkboxs_data , only: [:new, :edit]

  def new
    @reservation_examination = ReservationExamination.new
    # @reservation_examinations = @reservation.reservation_examinations
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
    @reservation_examination = ReservationExamination.first
    @ids = @reservation.reservation_examinations.pluck(:examination_id)
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

  def find_reservation
    @reservation = Reservation.find_by(id: params[:reservation_id])
  end

  def prepare_checkboxs_data
    @examination_groups = ExaminationGroup.all
  end
end
