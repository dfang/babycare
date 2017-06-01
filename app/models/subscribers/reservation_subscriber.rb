class ReservationSubscriber
  def reservation_create_successful(reservation)
    ReservationBroadcastJob.perform_later reservation
  end

  def reservation_prepay_successful(reservation)
    p reservation
    Rails.logger.info 'notify somebody reservation_prepay_successful'

    Doctor.verified.find_each do |doctor|
      SmsNotifyAllWhenNewReservationJob.perform_now(doctor.mobile_phone, reservation.patient_user_name)
    end
  end

  def reservation_reserve_successful(reservation)
    p reservation
    Rails.logger.info 'notify somebody reservation_reserve_successful'
    params = [ reservation.doctor_user_name, reservation.reserved_time, reservation.reserved_location ]
    SmsNotifyUserWhenReservedJob.perform_now(reservation.patient_user_phone, params)
  end

  def reservation_diagnose_successful(reservation)
    p reservation
    Rails.logger.info 'notify somebody reservation_diagnose_successful'
    SmsNotifyUserWhenDiagnosedJob.perform_now(reservation.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
  end

  def reservation_pay_successful(reservation)
    Rails.logger.info 'notify somebody reservation_pay_successful'

    ActiveRecord::Base.transaction do
      # increase doctor's income
      amount = reservation.prepay_fee.to_f + reservation.pay_fee.to_f
      source = (reservation.pay_fee.nil? || reservation.pay_fee.zero?) ? :online_consult : :offline_consult

      # increase doctor's wallet unwithdrawable amount
      reservation.doctor_user.increase_income(amount, source, reservation.id)
    end

    params = [reservation.patient_user_name]
    SmsNotifyDoctorWhenPaidJob.perform_now(reservation.doctor_user_phone, params)
  end

  def reservation_rate_successful(reservation)
    Rails.logger.info 'notify somebody reservation_rate_successful'
  end
end
