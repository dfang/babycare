# frozen_string_literal: true

class ReservationExaminationImageSubscriber
  class << self
    def create_reservation_examination_image_successful(image)
      Rails.logger.info 'create_reservation_examination_image_successful'
      ProcessWxImageJob.perform_now(image) if image.media_id.present? && image.data.blank?
    end

    def update_reservation_examination_image_successful(image)
      Rails.logger.info 'update_reservation_examination_image_successful'
      ProcessWxImageJob.perform_now(image) if image.media_id.present? && image.media_id_changed?
    end

    def destroy_reservation_examination_image_successful(_image)
      Rails.logger.info 'destroy_reservation_examination_image_successful'
      # TODO: 从七牛删除该图片
    end
  end
end
