# frozen_string_literal: true

class RatingsController < InheritedResources::Base
  belongs_to :reservation

  def create
    ratings = Rating.where(reservation_id: params[:reservation_id], rated_by: params[:rated_by])
    ratings.destroy_all if ratings.present?
    create! do
      if current_user.verified_doctor?
        doctors_reservation_path(parent)
      else
        patients_reservation_path(parent)
      end
    end
  end

  private

  def rating_params
    params.require(:rating).permit!
  end
end
