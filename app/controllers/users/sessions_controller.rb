# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!

  # before_action :wechat_authorize
  # before_action :configure_sign_in_params, only: [:create]
  # prepend_before_action :authenticate_user!, :wechat_authorize
  # before_action :authenticated?, only: [:wechat_authorize]

  before_action :request_code_for_mp, only: [:wechat_authorize]
  before_action :request_code_for_open_web, only: [:wechat_scan]

  before_action :exchange_code_for_access_token_info, :exchange_access_token_for_snsapi_userinfo, only: [:auth_callback]

  def new
    Rails.logger.info "session[:user_return_to] #{session[:user_return_to]}"
    if @browser.wechat?
      redirect_to :wechat_authorize and return
    else
      super
    end
  end

  # 微信网页授权登录
  def wechat_authorize
  end

  # 微信网页扫码登录
  def wechat_scan
  end

  # 授权之后或扫码之后的回调
  def auth_callback
  end

  protected

  def authenticated?
    if session[:weixin_openid].present? && @code.blank?
      Rails.logger.debug "authenticating user, session[:weixin_openid] is #{session[:weixin_openid]}"
      @authentication = Authentication.find_by provider: 'wechat', uid: session[:weixin_openid]

      # 微信登录状态下
      if @authentication.present?
        Rails.logger.info "authentication id is ::::::: #{authentication.id}"
        # authentication = nil if authentication.unionid.blank?
        @authentication = nil if @authentication.uid.blank?

        # Rails.logger.debug 'Authentication exists, sign in user automatically
        sign_in(:user, @authentication.user)
        # Rails.logger.debug 'redirecting ................'
        # respond_with authentication.user, location: after_sign_in_path_for(authentication.user)
        redirect_after_sign_in
      end
    end
  end

  # 1. 公众号授权第一步：用户同意授权，获取code
  def request_code_for_mp
    redirect_uri = URI.encode(Settings.mp.redirect_uri, /\W/)
    request_code_uri = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Settings.mp.app_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=snsapi_userinfo&state=babycare#wechat_redirect"
    Rails.logger.info request_code_uri
    redirect_to(request_code_uri) && return
  end

  # 1. 微信扫码登录第一步
  def request_code_for_open_web
    redirect_uri = URI.encode(Settings.open_web.redirect_uri, /\W/)
    request_code_uri = "https://open.weixin.qq.com/connect/qrconnect?appid=#{Settings.open_web.app_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=snsapi_login&state=#{Settings.open_web.state}#wechat_redirect"
    redirect_to(request_code_uri) && return
  end

  # 2 第二步：通过code换取网页授权access_token
  def exchange_code_for_access_token_info
    code = params[:code] if params.key?(:code)
    Rails.logger.info 'exchange_code_for_access_token_info'

    if browser.wechat?
      app_id = Settings.mp.app_id
      app_secret = Settings.mp.app_secret
    else
      app_id = Settings.open_web.app_id
      app_secret = Settings.open_web.app_secret
    end
    @access_token_info = code_for_access_token_info(code, app_id, app_secret);
  end

  # 3 第三步：拉取用户信息(需scope为 snsapi_userinfo), 并且创建Authentication
  def exchange_access_token_for_snsapi_userinfo
    Rails.logger.info 'exchange_access_token_for_snsapi_userinfo'

    # @userinfo = exchange_access_token_for_userinfo(Rails.cache.fetch('access_token_when_authorizing'), Rails.cache.fetch('openid_when_authorizing'))

    @userinfo = exchange_access_token_for_userinfo(@access_token_info['access_token'], @access_token_info['openid'])

    # 有error_code, 一般是过期了，那就刷新token， 看第三步
    # https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140842
    # invalid credential, access_token is invalid or not latest
    if @userinfo['errcode'].present? && @userinfo['errcode'] == 40_001
      # @access_token_info = refresh_token(Rails.cache.fetch(:refresh_token_when_authorizing))
      @access_token_info = refresh_token(@access_token_info['refresh_token'])

      # invalid refresh_token
      if @access_token_info['errcode'] == 40_030
        # Rails.cache.delete('refresh_token_when_authorizing')
        # Rails.cache.delete('openid_when_authorizing')
        # Rails.cache.delete('unionid_when_authorizing')
        # Rails.cache.delete('access_token_when_authorizing')

        redirect_to(wechat_authorize_path) && return
      end
      # @userinfo = exchange_access_token_for_userinfo(Rails.cache.fetch('access_token_when_authorizing'), Rails.cache.fetch('openid_when_authorizing'))
      @userinfo = exchange_access_token_for_userinfo(@access_token_info['access_token'], @access_token_info['openid'])
    end

    @authentication = Authentication.find_by(provider: 'wechat', unionid: @userinfo['unionid'])
    if @authentication.blank? || @authentication.user.blank?
      # Transaction create wechat authentication and user

      begin
        ActiveRecord::Base.transaction do
          @user = User.create_wechat_user(
            OpenStruct.new(
              nickname:   @userinfo['nickname'],
              sex:        @userinfo['sex'],
              headimgurl: @userinfo['headimgurl'],
              openid:     @userinfo['openid'],
              unionid:    @userinfo['unionid']
            )
          )

          p 'user created ###########################'
          @authentication = @user.create_wechat_authentication({ provider: 'wechat',
                                                               nickname:   @userinfo['nickname'],
                                                               uid:     @userinfo['openid'],
                                                               unionid:    @userinfo['unionid'] })
          p 'authentication created  ###########################'
        end
      rescue StandardError => e
        Rails.logger.info e.message
        raise ActiveRecord::Rollback
      end
      Rails.logger.info "Authentication inspected : #{@authentication.inspect}"
    end
    sign_in(:user, @authentication.user)
    redirect_after_sign_in
  end

  def redirect_after_sign_in
    # Rails.logger.info 'redirect_after_sign_in 根据不同的情况跳转到不同的页面'
    # redirect_to(edit_patients_settings_path) && return unless current_user.profile_complete?
    Rails.logger.info session[:user_return_to]
    redirect_to(session[:user_return_to]) && return if session[:user_return_to]
    redirect_to(root_path) && return
  end

  def build_request_code_uri(redirect_uri, app_id, app_secret)
  end

  def refresh_token(refresh_token)
    url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{Settings.mp.app_id}&grant_type=refresh_token&refresh_token=#{refresh_token}"
    @access_token_info = JSON.parse(Faraday.get(url).body)
    unless @access_token_info['errcode']
      Rails.cache.fetch :access_token_when_authorizing, expires_in: 7200.seconds do
        @access_token_info['access_token']
      end

      Rails.cache.fetch :openid_when_authorizing, expires_in: 7200.seconds do
        @access_token_info['openid']
      end

      Rails.cache.fetch :unionid_when_authorizing, expires_in: 7200.seconds do
        @access_token_info['unionid']
      end

      Rails.cache.fetch :refresh_token_when_authorizing, expires_in: 30.days do
        @access_token_info['refresh_token']
      end
    end
    @access_token_info
  end

  def code_for_access_token_info(code, app_id, app_secret)
    token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{app_id}&secret=#{app_secret}&code=#{code}&grant_type=authorization_code"
    access_token_info ||= JSON.parse(Faraday.get(token_url).body)
    Rails.logger.info access_token_info

    if access_token_info["access_token"].present?
      return access_token_info
    else
      # retry
    end
  end

  def exchange_access_token_for_userinfo(access_token, openid)
    uinfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
    uinfo_response_data = JSON.parse(Faraday.get(uinfo_url).body)
    Rails.logger.info "\n\nexchange_access_token_for_userinfo response data is \n #{uinfo_response_data}\n\n"
    uinfo_response_data
  end
end
