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
    pc = WXBizDataCrypt.new(app_id, session_key)
    pc.decrypt(encrypted_data, iv)
  end

  def payload(authentication)
    return nil unless authentication and authentication.unionid
    {
      web_token: JsonWebToken.encode({unionid: authentication.unionid}),
    }
  end
end
