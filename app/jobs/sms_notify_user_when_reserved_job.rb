# frozen_string_literal: true

class SmsNotifyUserWhenReservedJob < ApplicationJob
  queue_as :urgent

  def perform(to, *args)
    IM::Ronglian.new.send_templated_sms(to, Settings.sms_templates.notify_user_when_reserved, args)
  end
end
