# frozen_string_literal: true

class SmsNotifyAllWhenNewReservationJob < ActiveJob::Base
  queue_as :urgent

  def perform(to, *args)
    IM::Ronglian.new.send_templated_sms(to, Settings.sms_templates.notify_all_when_new_reservation, args)
  end
end
