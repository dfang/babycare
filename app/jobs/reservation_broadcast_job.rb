class ReservationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ActionCable.server.broadcast 'reservation_channel', message: "reservation created"
  end
end
