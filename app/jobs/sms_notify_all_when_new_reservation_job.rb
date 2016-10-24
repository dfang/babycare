class SmsNotifyAllWhenNewReservationJob < ActiveJob::Base
  queue_as :urgent

  def perform(*args)
    IM::Ronglian.send_templated_sms()
  end
end
