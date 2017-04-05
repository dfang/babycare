class ImagingExaminationImageObserver < ActiveRecord::Observer
  def after_save(image)
    if image.media_id.present? && image.media_id_changed?
      ProcessWxImageJob.perform_now(image)
    end
  end
end
