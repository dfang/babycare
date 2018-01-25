# frozen_string_literal: true

class DoctorSubscriber
  class << self
    def update_doctor_successful(doctor)
      Rails.logger.info 'subscribed'

      Rails.logger.info doctor.id_card_front_media_id
      Rails.logger.info doctor.id_card_front_media_id.present?
      Rails.logger.info doctor.id_card_front_media_id_changed?

      if doctor.license_front_media_id.present?
        ProcessDoctorLicenceFrontImageJob.perform_now(doctor)
      end

      if doctor.license_back_media_id.present?
        ProcessDoctorLicenceBackImageJob.perform_now(doctor)
      end

      if doctor.id_card_front_media_id.present?
        ProcessDoctorIdCardFrontImageJob.perform_now(doctor)
      end

      if doctor.id_card_back_media_id.present?
        ProcessDoctorIdCardBackImageJob.perform_now(doctor)
      end
    end

    def doctor_verified_successful(doctor)
      Rails.logger.info 'notify doctor verified'
      NotifyDoctorVerifiedJob.perform_later(doctor)
    end
  end
end
