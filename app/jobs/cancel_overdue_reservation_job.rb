class CancelOverdueReservationJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # todo: 超过1小时未支付定金的订单, 自动取消, 不回到公共池，需要手动激活
    Reservation.reserved.find_each do |reservation|
      if reservation.updated_at + 1.hour < Time.now
        reservation.update(aasm_state: :overdued)
        # todo maybe 发短信通知医生
      end
    end
  end
end
