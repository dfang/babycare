# frozen_string_literal: true

class Doctors::RatingsController < InheritedResources::Base

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
