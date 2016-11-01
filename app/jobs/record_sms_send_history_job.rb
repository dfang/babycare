class RecordSmsSendHistoryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts 'record sms send history job'
  end
end
