# frozen_string_literal: true

class ReservationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    Rails.logger.info "broadcast reservation created ......."
    ActionCable.server.broadcast 'reservation_channel', message: 'reservation created'
  end
end
