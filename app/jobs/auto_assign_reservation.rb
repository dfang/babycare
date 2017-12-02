# frozen_string_literal: true

class AutoAssignReservation < ApplicationJob
  queue_as :default

  def perform(reservation)
    return unless Rails.env.staging? && Rails.env.development?
    return unless ENV['AutoAssignReservation'] == 'true'
    return unless Doctor.any?

    if ENV['AutoAssignReservationRandomly'] == 'true'
      Rails.logger.info 'auto assign reservation to random selected doctor'
      doctor_id = Doctor.order('RANDOM()').first.id
    else
      Rails.logger.info 'auto assign reservation to the first only doctor'
      doctor_id = Doctor.first.id
    end

    assign_reservertion(reservation, doctor_id)
  end

  private

  def assign_reservertion(reservation, doctor_id)
    reservation.update_column(doctor_id: doctor_id)
  end
end
