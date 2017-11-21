class Patients::ExaminationsController < ApplicationController
  def destroy
    @reservation = current_user.reservations.find_by(id: params[:id])
    @examination = @reservation.reservation_examinations.find_by(id: params[:reid])
    @image = @examination.reservation_examination_images.find_by(id: params[:imgid])
    @image.destroy if @image.present?
    redirect_to examinations_uploader_patients_reservations_path(id: @reservation)
  end
end
