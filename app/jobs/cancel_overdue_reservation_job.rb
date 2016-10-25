class CancelOverdueReservationJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # todo: 超过1小时未支付定金的订单, 自动取消, 不回到公共池，需要手动激活
  end
end
