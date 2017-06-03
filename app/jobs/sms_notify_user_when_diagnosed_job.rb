# frozen_string_literal: true

class SmsNotifyUserWhenDiagnosedJob < ActiveJob::Base
  queue_as :urgent

  def perform(to, *_args)
    IM::Ronglian.new.send_templated_sms(to, Settings.sms_templates.notify_user_when_diagnosed)
  end
end
