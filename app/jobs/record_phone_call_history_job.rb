# frozen_string_literal: true

class RecordPhoneCallHistoryJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # RecordPhoneCallHistoryJob.perform_later(caller_id, callee_id, reservation_id, caller_phone, callee_phone)
    reservation = Reservation.find_by(id: args[2].to_i)
    reservation_state_when_call = reservation.aasm_state.to_s if reservation.present?

    PhoneCallHistory.create(
      caller_user_id: args[0],
      callee_user_id: args[1],
      reservation_id: args[2],
      caller_phone: args[3],
      callee_phone: args[4],
      reservation_state_when_call: reservation_state_when_call
    )
  end
end
