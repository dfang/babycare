# encoding: utf-8

class ImageUploader < BaseVersionUploader
  VERSIONS = {
    mini:         { width: 30, height: 30 },
    normal:       { width: 75, height: 75 },
    large:        { width: 180, height: 180 },
    for_crop:     { width: 500, thumbnail_model: 2 },
    crop_preview: { width: 120, height: 120}
  }

  def crop!(crop_x, crop_y, crop_w, crop_h)
    data = Qiniu.get(self.qiniu_bucket, current_path)
    src_img_url = data['url']

    crop_name ||= ::SecureRandom.uuid
    extname ||= File.extname(current_path).downcase
    target_key = "#{store_dir}/#{crop_name}#{extname}"

    mogrify_options = {
      :thumbnail => "!500", # 此处为宽度，请注意和上面的for_crop的version保持一致
      :crop => "!#{crop_w}x#{crop_h}a#{crop_x}a#{crop_y}"
    }
    result = Qiniu.image_mogrify_save_as(self.qiniu_bucket, target_key, src_img_url, mogrify_options)
    if result
      model.update_attribute(:croped_image, "#{crop_name}#{extname}")
    end
  end

  def store_dir
    'avatars'
  end
end
