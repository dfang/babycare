# frozen_string_literal: true

class AutoAssignReservationInStagingJob < ApplicationJob
  queue_as :default

  def perform()
    if Rails.env.staging? && Rails.env.development?
        if ENV['AutoAssignReservationInStaging'] == "true" || ENV['AutoAssignReservationInDevelopment'] == "true"
            Rails.logger.info "auto assign reservation to random selected doctor"
            if Doctor.any?
                Reservation.prepaid.each do |res|
                    res.update_column(doctor_id: Reservation.first(:order => "RANDOM()").id)
                end
            end
        end
    end
  end
end
