class RatingsController < InheritedResources::Base
	belongs_to :reservation

	def create
		rating = Rating.find_by(reservation_id: params[:reservation_id], rated_by: params[:rated_by])
		rating.destroy! if rating.present?
		create! {
			resource.tag_list = rating_params[:body]
			resource.save!

			if current_user.is_verified_doctor?
				my_doctors_reservation_path(parent)
			else
				my_patients_reservation_path(parent)
			end
		}
	end

	private

	def rating_params
		params.require(:rating).permit!
	end

end
