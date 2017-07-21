require 'wxbiz_data_crypt'

class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token
  # def authenticate_user
  #   user = User.find_for_database_authentication(email: params[:email])
  #   if user.valid_password?(params[:password])
  #     render json: payload(user)
  #   else
  #     render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
  #   end
  # end
  #
  # private
  #
  # def payload(user)
  #   return nil unless user and user.id
  #   {
  #     auth_token: JsonWebToken.encode({user_id: user.id}),
  #     user: {id: user.id, email: user.email}
  #   }
  # end

  def authenticate_token
    code = request.headers['code']
    encrypted_data = request.headers['encryptedData']
    iv = request.headers['iv']
    Rails.logger.info "code is #{code}"

    session_key = get_session_key(code)

    # =======test data============
    # session_key = 'qftqHnfyC4FC9s4QXV3N0g=='
    # iv = 'OExxLYUnrJxpWrTLJYzFfQ=='
    # encrypted_data = 'kdvLdX82+h1sST9i0sINYz/OHVEvelauSmu+Kqy44rnUuP8A4THCC16NvfReQPmxxf9THcdqeYBJCw56AwnBc8fa8TrzwBjDO3Am/1aouBzUcCg2nYnhcsDenHbqi4IMCWy2wrjjrlYafOPBsgB4QL/JZHP2pHpc6eqQAoGSbizWWPw0CfZ/0g425S6CSblZhfR0ryArp4kT478SGiySFQgl0C/yJ5Cm7C0OyE9pBigvc5/341ODsHgkuL3c8bKR4FIwqPzWEDPJiKY+KZRyjkDfOrdMobwZQdtgmleWGPSeZCeuSWL2IOS2wUF0BYeeaZK0V/fDMHkQt4tNt+cNp1S/z0DY63Xg0f5NJt8RTGyWbtKz9sUX7xI/GFWeDkYddOEk58EjGedLl/UNNeazTQkbwIvD1KJyLybO5cmK1hQ+CIlW7WB1PUM1bj7re3x6ZTT4rzjPAkm3ZhUytU5f5dKE6T6iXfyABNli/JRoALseT+dFQm9oHttD+duNkx4YQdRPu+62DBuXpGrBIPVb7/ckB9U49ikdyqGFKpG4+yk='
    # =============================

    decrypted_data = decrypt(session_key, encrypted_data, iv)
    Rails.logger.info "decrypted_data is #{decrypted_data}"
    unionid = decrypted_data['unionId']

    authentication = Authentication.find_by_unionid(unionid)
    if authentication.present?
      render json: payload(authentication)
    else
      render json: {errors: ['Invalid unionid']}, status: :unauthorized
    end
  end

  private

  def get_session_key(code)
    # 通过code换取微信小程序的 session_key 和 openid
    token_url = "https://api.weixin.qq.com/sns/jscode2session?appid=#{Settings.weixin_mp.app_id}&secret=#{Settings.weixin_mp.app_secret}&js_code=#{code}&grant_type=authorization"
    token_info_response_data = JSON.parse(Faraday.get(token_url).body)
    Rails.logger.info "\n\n get_session_key response data is \n #{token_info_response_data}\n\n"
    token_info_response_data['session_key']
  end

  def decrypt(session_key, encrypted_data, iv)
    app_id = Settings.weixin_mp.app_id
    WxBizDataCrypt.new(app_id).decrypt(session_key, encrypted_data, iv)
  end

  def payload(authentication)
    return nil unless authentication and authentication.unionid
    {
      web_token: JsonWebToken.encode({unionid: authentication.unionid}),
    }
  end
end
