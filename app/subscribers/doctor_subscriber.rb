# frozen_string_literal: true

class DoctorSubscriber
  class << self
    def update_doctor_successful(doctor)
      Rails.logger.info 'subscribed'

      if doctor.license_front_media_id.present? && doctor.license_front_media_id_changed?
        ProcessDoctorLicenceFrontImageJob.perform_now(doctor)
      end

      if doctor.license_back_media_id.present? && doctor.license_back_media_id_changed?
        ProcessDoctorLicenceBackImageJob.perform_now(doctor)
      end

      if doctor.id_card_front_media_id.present? && doctor.id_card_front_media_id_changed?
        ProcessDoctorIdCardFrontImageJob.perform_now(doctor)
      end

      if doctor.id_card_back_media_id.present? && doctor.id_card_back_media_id_changed?
        ProcessDoctorIdCardBackImageJob.perform_now(doctor)
      end
    end

    def doctor_verified_successful(doctor)
      Rails.logger.info 'notify doctor verified'
      NotifyDoctorVerifiedJob.perform_later(doctor)
    end
  end
end
