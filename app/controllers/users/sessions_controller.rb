class Users::SessionsController < Devise::SessionsController
  before_action :wechat_authorize
  # before_action :configure_sign_in_params, only: [:create]

  def wechat_authorize
    wx_authenticate!
  end

  protected


  def wx_authenticate!

    if session[:weixin_openid].present?
      authentication = Authentication.find_by provider: 'wechat', uid: session[:weixin_openid]
      if authentication.present?
        Rails.logger.info "authentication id is ::::::: #{authentication.id}"
        authentication = nil if authentication.unionid.blank?
      end
    end

    # 当session中没有openid时，则为微信没有登录的状态
    if session[:weixin_openid].blank? || authentication.blank?

      code = params[:code]
      Rails.logger.info "code: #{code}"

      # 如果code参数为空，则为认证第一步，重定向到微信认证
      if code.nil?
        url = URI.encode(request.url, /\W/)
        Rails.logger.info "redirect_uri is #{url}"
        redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{WxApp::WEIXIN_ID}&redirect_uri=#{url}&response_type=code&scope=snsapi_userinfo&state=babycare#wechat_redirect"
        return
      end

      #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
      begin
        token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{WxApp::WEIXIN_ID}&secret=#{WxApp::WEIXIN_SECRET}&code=#{code}&grant_type=authorization_code"

        # token_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{WxApp::WEIXIN_ID}&secret=#{WxApp::WEIXIN_SECRET}"
        token_info = JSON.parse Faraday.get(token_url).body


        unless token_info['errcode']
          Rails.logger.info "\ntoken_info: #{token_info.inspect}\n"
          openid = token_info['openid']
          access_token = token_info['access_token']

          uinfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
          union_info = JSON.parse Faraday.get(uinfo_url).body

          # 微信API调整了 get union id http://mp.weixin.qq.com/wiki/1/8a5ce6257f1d3b2afb20f83e72b72ce9.html
          # union_url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{WxApp.get_access_token}&openid=#{openid}&lang=zh_CN"
          # union_info = JSON.parse Faraday.get(union_url).body

          Rails.logger.info "\nunion_info: #{union_info.inspect}\n"

          # 微信公众号绑定到微信公众开发平台上才能获取到unionid, 此处用的是测试号，所以自己随变弄一个算了
          unionid = union_info['openid']
          # unionid = union_info['unionid']

          Rails.logger.info "uinfo_url: #{uinfo_url} \n"
          userinfo = JSON.parse Faraday.get(uinfo_url).body
          Rails.logger.info "userinfo: #{userinfo.inspect}\n"

          # binding.pry
          authentication = Authentication.where(provider: 'wechat', unionid: unionid).first
          if authentication.blank?
            if authentication = Authentication.where(provider: 'wechat', uid: openid).first
              authentication.update_column :unionid, unionid
              user = authentication.user
            else
              wechat_session =  OpenStruct.new(
                nickname:   userinfo['nickname'],
                sex:        userinfo['sex'],
                headimgurl: userinfo['headimgurl'],
                openid:     userinfo['openid'],
                unionid:    union_info['unionid']
              )
              p '#######################'
              p 'creating user ###########################'
              p '#######################'

              user = User.create_wechat_user(wechat_session)
              p userinfo
              p wechat_session

              p '#######################'
              p 'creating authentication ###########################'
              p '#######################'

              authentication = Authentication.create_from_omniauth_hash(wechat_session, user.id)
            end
            Rails.logger.info "authentication--: #{authentication.inspect}"
          end

          session[:weixin_openid] = openid
          sign_in(:user, authentication.user)
          # respond_with authentication.user, location: after_sign_in_path_for(authentication.user)
          redirect_after_sign_in
        end
      rescue Exception => e
        Rails.logger.info e.inspect
        redirect_to root_path
      end

    # 微信登录状态下
    elsif authentication
      Rails.logger.debug "Authentication exists, sign in user automatically"
      user = authentication.user
      sign_in(:user, authentication.user)
      Rails.logger.debug "redirecting ................"
      # respond_with authentication.user, location: after_sign_in_path_for(authentication.user)
      redirect_after_sign_in
    end
  end

  def redirect_after_sign_in
    if session[:user_return_to]
      redirect_to session[:user_return_to]
    else
      redirect_to root_path and return
    end
  end
end
