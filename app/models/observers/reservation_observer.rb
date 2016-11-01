class ReservationObserver < ActiveRecord::Observer
  def after_save(reservation)
    if reservation.rated?
      reservation.rate!
    end
  end

  def after_create(reservation)
    # todo: delay job
    Doctor.verified.find_each do |doctor|
      SmsNotifyAllWhenNewReservationJob.perform_now(doctor.mobile_phone, reservation.patient_user_name)
    end
  end
end
