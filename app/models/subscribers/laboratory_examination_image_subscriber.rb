class LaboratoryExaminationImageSubscriber
  def after_commit(image)
    if image.media_id.present? && image.media_id_changed?
      ProcessWxImageJob.perform_now(image)
    end
  end
end
