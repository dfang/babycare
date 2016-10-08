require 'rqrcode'

class UserObserver < ActiveRecord::Observer

  # def after_save(user)
  #   # todo: delay job to create qrcode
  #   qrcode = RQRCode::QRCode.new("http://github.com/")
  #   png = qrcode.as_png(
  #         resize_gte_to: false,
  #         resize_exactly_to: false,
  #         fill: 'white',
  #         color: 'black',
  #         size: 120,
  #         border_modules: 4,
  #         module_px_size: 6,
  #         file: nil # path to write
  #         )
  #
  #   user.qrcode_data_uri = png.to_data_url
  #   user.save!
  # end
end
