# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :wechat_authorize
  # before_action :configure_sign_in_params, only: [:create]
  # prepend_before_action :authenticate_user!, :wechat_authorize

  def wechat_authorize
    wx_authenticate!
  end

  def wxapp_login
    p request
    Rails.logger.info request
  end

  protected

  # FIXME
  # rubocop:disable Metrics/MethodLength
  def wx_authenticate!
    # 微信网页授权文档
    # https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140842&token=&lang=zh_CN

    if session[:weixin_openid].present? || cookies[:weixin_openid].present?
      Rails.logger.debug "authenticating user, session[:weixin_openid] is #{session[:weixin_openid]}"
      authentication = Authentication.find_by provider: 'wechat', uid: session[:weixin_openid] || cookies[:weixin_openid]
      if authentication.present?
        Rails.logger.info "authentication id is ::::::: #{authentication.id}"
        # authentication = nil if authentication.unionid.blank?
        authentication = nil if authentication.uid.blank?
      end
    end

    # 当session中没有openid时，则为微信没有登录的状态
    if session[:weixin_openid].blank? || authentication.blank?
      Rails.logger.debug 'session[:weixin_openid] is nil, 没有授权过, 现在开始授权'

      code = params[:code]
      Rails.logger.debug "code: #{code}"

      # 认证第一步，如果code参数为空，那就重定向到微信认证去请求code参数
      if code.nil?
        redirect_uri = URI.encode(request.url, /\W/)

        Rails.logger.debug 'code参数为空，那就重定向到用户同意授权，获取code参数'
        Rails.logger.debug '正常情况下，用户点击授权按钮就会去申请code参数，如果曾经授权过，此时静默授权，用户无感知'
        Rails.logger.debug "redirect_uri is #{redirect_uri}"

        redirect_to(get_code_uri(redirect_uri)) && return
      end

      # 如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
      begin
        Rails.logger.debug 'code参数不为空,通过code获取openid和access_token'

        token_info = exchange_code_for_access_token(code)

        unless token_info['errcode']

          Rails.logger.debug "\ntoken_info: #{token_info.inspect}\n"

          openid = token_info['openid']
          access_token = token_info['access_token']

          Rails.logger.debug '通过openid和access_token获取用户信息'

          userinfo = exchange_access_token_for_userinfo(access_token, openid)

          # 微信API调整了 get union id http://mp.weixin.qq.com/wiki/1/8a5ce6257f1d3b2afb20f83e72b72ce9.html
          # union_url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{WxApp::WxCommon.get_access_token}&openid=#{openid}&lang=zh_CN"
          # union_info = JSON.parse Faraday.get(union_url).body

          # 微信公众号绑定到微信公众开发平台上才能获取到unionid, 此处用的是测试号，所以自己随变弄一个算了
          unionid = userinfo['openid']
          # unionid = union_info['unionid']

          authentication = Authentication.find_by(provider: 'wechat', unionid: unionid)
          if authentication.blank?
            if authentication = Authentication.find_by(provider: 'wechat', uid: openid)
              authentication.update_column :unionid, unionid
              user = authentication.user
            else

              # Transaction create wechat authentication and user
              Authentication.transaction do
                p userinfo
                wechat_session = create_wechat_session(userinfo, userinfo)
                p wechat_session
                user = User.create_wechat_user(wechat_session)
                p 'user created ###########################'

                authentication = Authentication.create_from_omniauth_hash(wechat_session, user.id)
                p 'authentication created  ###########################'
              end

            end
            Rails.logger.info "Authentication inspected : #{authentication.inspect}"
          end

          session[:weixin_openid] = openid
          cookies[:weixin_openid] = openid
          sign_in(:user, authentication.user)
          # respond_with authentication.user, location: after_sign_in_path_for(authentication.user)

          # redirect_after_sign_in
          redirect_to(edit_patients_settings_path) && return
        end
      rescue StandardError => e
        Rails.logger.info e.inspect
        redirect_to root_path
      end

    # 微信登录状态下
    elsif authentication
      Rails.logger.debug 'Authentication exists, sign in user automatically'
      user = authentication.user
      sign_in(:user, authentication.user)
      Rails.logger.debug 'redirecting ................'
      # respond_with authentication.user, location: after_sign_in_path_for(authentication.user)
      redirect_after_sign_in
    end
  end

  def redirect_after_sign_in
    if session[:user_return_to]
      redirect_to session[:user_return_to]
    else
      redirect_to(root_path) && return
    end
  end

  def get_code_uri(redirect_uri)
    uri_for_get_code_from_weixin = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{WxApp::WxCommon::WEIXIN_ID}&redirect_uri=#{redirect_uri}&response_type=code&scope=snsapi_userinfo&state=babycare#wechat_redirect"
    uri_for_get_code_from_weixin
  end

  def exchange_code_for_access_token(code)
    # 通过code换取的是一个特殊的网页授权access_token,与基础支持中的access_token（该access_token用于调用其他接口）不同
    token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{WxApp::WxCommon::WEIXIN_ID}&secret=#{WxApp::WxCommon::WEIXIN_SECRET}&code=#{code}&grant_type=authorization_code"
    token_info = JSON.parse(Faraday.get(token_url).body)
    token_info
  end

  def exchange_access_token_for_userinfo(access_token, openid)
    uinfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
    union_info = JSON.parse(Faraday.get(uinfo_url).body)
  end

  def create_wechat_session(userinfo, union_info)
    OpenStruct.new(
      nickname:   userinfo['nickname'],
      sex:        userinfo['sex'],
      headimgurl: userinfo['headimgurl'],
      openid:     userinfo['openid'],
      unionid:    union_info['unionid']
    )
  end
end
