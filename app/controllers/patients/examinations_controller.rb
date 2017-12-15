# frozen_string_literal: true

class Patients::ExaminationsController < ApplicationController
  def destroy
    @reservation = current_user.reservations.find_by(id: params[:id])
    @examination = @reservation.reservation_examinations.find_by(id: params[:reid])
    @image = @examination.reservation_examination_images.find_by(id: params[:imgid])
    @image.destroy if @image.present?
  end
end
