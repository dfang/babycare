class DoctorObserver < ActiveRecord::Observer
  def after_save(doctor)
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
    # license_front
    # id_card_back
    # license_back
    # id_card_front
  end
end
