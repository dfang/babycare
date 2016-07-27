
class SmsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    SmartSMS.deliver 156189030080, 'aaa', tpl_id: 1
  end
end


