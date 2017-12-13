# frozen_string_literal: true

class WxBizDataCrypt
  def initialize(app_id)
    @app_id = app_id
  end

  def decrypt(session_key, encrypted_data, iv)
    encrypted_data = Base64.decode64(encrypted_data)
    iv = Base64.decode64(iv)
    session_key = Base64.decode64(session_key)

    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.decrypt
    cipher.key = session_key
    cipher.iv  = iv
    cipher.padding = 0
    data = cipher.update(encrypted_data) + cipher.final

    result = JSON.parse(data[0...-data.last.ord])

    raise '解密错误' if result['watermark']['appid'] != @app_id
    result
  end
end
