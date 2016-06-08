# encoding: utf-8

class ImageUploader < BaseVersionUploader
  VERSIONS = {
    mini:         { width: 30, height: 30 },
    normal:       { width: 75, height: 75 },
    large:        { width: 180, height: 180 },
    for_crop:     { width: 500, thumbnail_model: 2 },
    crop_preview: { width: 120, height: 120}
  }

  def store_dir
    'images'
  end
end
