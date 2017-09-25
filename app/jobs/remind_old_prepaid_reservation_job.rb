# frozen_string_literal: true

class RemindOldPrepaidReservationJob < ApplicationJob
  queue_as :default

  def perform(*)
    # TODO: 支付了定金但是超过15分钟还没医生接单通知我们自己的客服
    Reservation.prepaid.find_each do |reservation|
      if reservation.updated_at + 15.minutes < Time.zone.now
        # TODO: notify support
      end
    end
  end
end
