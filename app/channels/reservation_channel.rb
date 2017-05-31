class ReservationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reservation_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
