class ReservationObserver < ActiveRecord::Observer
  def after_save(reservation)
    if reservation.rated?
      reservation.rate!
    end
  end

  def after_create(reservation)
    # todo: delay job
    Doctor.find_each do |doctor|
      # IM::Ronglian.send_templated_sms()
      SmsNotifyAllWhenNewReservationJob.perform!(doctor.mobile_phone, Settings.sms_templates.notify_all_when_new_reservation, reservation.patient_user_name)
    end
  end
end
