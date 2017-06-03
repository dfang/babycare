# frozen_string_literal: true

class ReservationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ActionCable.server.broadcast 'reservation_channel', message: 'reservation created'
  end
end
