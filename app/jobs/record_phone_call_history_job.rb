class RecordPhoneCallHistoryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    puts 'record phone call history job'

    # caller = User.find_by(id: params["caller"])
    # reservation = Reservation.find_by(id: params["reservation_id"])
    # reservation_state_when_call = reservation.aasm_state.to_s
    #
    # PhoneCallHistory.create(
    #   caller_user_id: params["caller"],
    #   caller_phone: caller.doctor.try(:mobile_phone),
    #   callee_user_id: params["callee"],
    #   callee_phone: params["reservation_phone"],
    #   reservation_id: params["reservation_id"],
    #   reservation_state_when_call: reservation_state_when_call
    # )


  end
end
