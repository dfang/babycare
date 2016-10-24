class SmsNotifyDoctorWhenPrepaidJob < ActiveJob::Base
  queue_as :urgent

  def perform(to, *args)
    IM::Ronglian.send_templated_sms(to, Settings.sms_templates.notify_doctor_when_prepaid, args)
  end
end
