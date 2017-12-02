# frozen_string_literal: true

class AutoAssignReservation < ApplicationJob
  queue_as :default

  def perform(reservation)
    if Rails.env.staging? && Rails.env.development?
        if ENV['AutoAssignReservation'] == "true"
            Rails.logger.info "auto assign reservation to random selected doctor"
            if Doctor.any?
                if ENV['AutoAssignReservationRandomly'] == "true"
                    reservation.update_column(doctor_id: Doctor.order("RANDOM()").first.id)
                else
                    reservation.update_column(doctor_id: Doctor.first.id)
                end
            end
        end
    end
  end
end
