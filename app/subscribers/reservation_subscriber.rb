# frozen_string_literal: true

class ReservationSubscriber
  class << self
    def create_reservation_successful(reservation)
      ReservationBroadcastJob.perform_now reservation
    end

    def after_prepaid(reservation)
      # TODO
      Rails.logger.info "#{reservation}"
      # 开发或者Staging模式下 自动分配给空闲的医生 方便测试
      AutoAssignReservation.perform_later(reservation)
      # 通知抢单制  现在分配制
      # Doctor.verified.find_each do |doctor|
      #   SmsNotifyAllWhenNewReservationJob.perform_now(doctor.mobile_phone, reservation.patient_user_name)
      # end
    end

    # def reservation_reserve_successful(reservation)
    #   Rails.logger.info 'notify somebody reservation_reserve_successful'
    #   params = [reservation.doctor_user_name, reservation.reserved_time, reservation.reserved_location]
    #   SmsNotifyUserWhenReservedJob.perform_now(reservation.patient_user_phone, params)
    # end

    def after_reserved_to_examine
      # TODO
    end

    def after_reserved_to_consult
      # TODO
    end

    def after_diagnosed(reservation)
      Rails.logger.info 'notify somebody reservation_diagnose_successful'
      SmsNotifyUserWhenDiagnosedJob.perform_now(reservation.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
    end

    def after_paid(reservation)
      Rails.logger.info 'notify somebody reservation_pay_successful'
      ActiveRecord::Base.transaction do
        # increase doctor's income
        amount = reservation.prepay_fee.to_f + reservation.pay_fee.to_f
        source = reservation.pay_fee.nil? || reservation.pay_fee.zero? ? :online_consult : :offline_consult
        # increase doctor's wallet unwithdrawable amount
        reservation.doctor_user.increase_income(amount, source, reservation.id)
      end
      params = [reservation.patient_user_name]
      SmsNotifyDoctorWhenPaidJob.perform_now(reservation.doctor_user_phone, params)
    end

    def after_rated(reservation)
      Rails.logger.info "#{reservation}"
    end
  end
end
