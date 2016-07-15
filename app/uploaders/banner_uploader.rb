class BannerUploader < BaseVersionUploader
  VERSIONS = {
    normal:  { width: 900, height: 280 },
    preview: { width: 450, height: 140 },
    side: { width: 210, height: 120 }
  }

  def store_dir
    'shop_banners'
  end
end
