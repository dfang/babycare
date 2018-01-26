# frozen_string_literal: true

class Doctors::RatingsController < Doctors::BaseController
  def create
    super do |format|
      format.html { redirect_to doctors_reservation_path(resource.reservation) }
    end
  end

  private

  def rating_params
    params.require(:rating).permit!
  end
end
