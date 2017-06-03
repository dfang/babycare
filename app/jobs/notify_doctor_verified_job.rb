# frozen_string_literal: true

class NotifyDoctorVerifiedJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # 通知医生审核通过
  end
end
