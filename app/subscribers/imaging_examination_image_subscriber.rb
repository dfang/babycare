# frozen_string_literal: true

class ImagingExaminationImageSubscriber
  class << self
    # def after_commit(image)
    #   ProcessWxImageJob.perform_now(image) if image.media_id.present? && image.media_id_changed?
    # end
  end
end
