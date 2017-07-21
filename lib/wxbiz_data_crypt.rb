class WxBizDataCrypt
  def initialize(app_id)
    @app_id = app_id
    # @session_key = Base64.decode64(session_key)
#  {"session_key"=>"k6jz2ERYZyGTS2II5OzlVA==", "expires_in"=>7200, "openid"=>"o2RIJ0XJT_G0Om7kWHfCg-10YbQE"}

    Rails.logger.info "\napp_id is #{app_id}"

  end

  def decrypt(session_key, encrypted_data, iv)
    encrypted_data = Base64.decode64(encrypted_data)
    iv = Base64.decode64(iv)
    Rails.logger.info "\nEncrypted_data is #{encrypted_data} \n\niv is #{iv}"

    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.decrypt
    cipher.padding = 0
    cipher.key = Base64.decode64(session_key)
    cipher.iv  = iv
    data = cipher.update(encrypted_data) + cipher.final
    Rails.logger.info "\n!!!!!data is #{data} !!!! , \n\ncipher_final is #{cipher.final}!!!!"

    Rails.logger.info(data[0...-data.last.ord])
    Rails.logger.info('\n\n\n')
    p(data[0...-data.last.ord])
    Rails.logger.info('\n\n\n')

    result = JSON.parse(data[0...-data.last.ord])
    Rails.logger.info "\nresult is #{result} ~~~~~~~~~\n"

    raise '解密错误' if result['watermark']['appid'] != @app_id
    result
  end
end
