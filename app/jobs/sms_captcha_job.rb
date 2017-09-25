# frozen_string_literal: true

class SmsCaptchaJob < ApplicationJob
  queue_as :urgent

  def perform(to, *args)
    IM::Ronglian.new.send_templated_sms(to, Settings.sms_templates.captcha, args)
  end
end
