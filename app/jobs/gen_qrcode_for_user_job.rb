# frozen_string_literal: true

class GenQrcodeForUserJob < ApplicationJob
  queue_as :urgent

  def perform(user)
    qrcode = RQRCode::QRCode.new("#{Settings.common.domain_name}/users/#{user.id}/scan_qrcode")
    png = qrcode.as_png(
            resize_gte_to: false,
            resize_exactly_to: false,
            fill: 'white',
            color: 'black',
            size: 300,
            border_modules: 4,
            module_px_size: 6,
            file: nil
        )
    image_path = "#{Rails.root.join('tmp',  "qrcode-#{user.id}.png")}"
    # png.save(image_path)
    # https://devhints.io/chunky_png


    File.open(image_path, 'wb') { |io| png.write(io) }
    user.update_attribute(:qrcode, File.open(image_path))

    # binary_string = image.to_blob
    # user.update_attribute(:qrcode, png.to_blob)
  end
end
