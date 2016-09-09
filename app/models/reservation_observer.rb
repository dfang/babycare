class ReservationObserver < ActiveRecord::Observer
  def after_save(reservation)
    if reservation.rated?
			reservation.rate!
		end
  end
end
