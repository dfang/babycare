class RecordSmsSendHistoryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # RecordSmsSendHistoryJob.perform_later(sender_user_id, sendee_user_id, sender_phone, sendee_phone, templateId, reservation_id)
    # p args
    # reservation = Reservation.find_by(id: args[5].to_i)
    # reservation_state_when_sms = reservation.aasm_state.to_s if reservation.present?

    # RecordSmsSendHistoryJob.perform_later(to, templateId)
    SmsHistory.create(
      sendee_phone: args[0],
      template_id: args[1]
      # sender_user_id: args[0],
      # sendee_user_id: args[1],
      # sender_phone: args[2],
      # reservation_id: args[5],
      # reservation_state_when_sms: reservation_state_when_sms
    )
  end
end
