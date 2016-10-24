class SmsNotifyUserWhenReservedJob < ActiveJob::Base
  queue_as :urgent

  def perform(to, *args)
    IM::Ronglian.send_templated_sms(to, Settings.sms_templates.notify_user_when_reserved, args)
  end
end
