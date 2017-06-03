# frozen_string_literal: true

class MedicalRecordImageSubscriber
  def after_commit(image)
    ProcessWxImageJob.perform_now(image) if image.media_id.present? && image.media_id_changed?
  end
end
