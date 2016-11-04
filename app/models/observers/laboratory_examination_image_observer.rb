class LaboratoryExaminationImageObserver < ActiveRecord::Observer
  def after_save(image)
    # binding.pry
    if image.data.blank? && image.media_id.present?
      ProcessWxImageJob.perform_now(image)
    end
  end
end
