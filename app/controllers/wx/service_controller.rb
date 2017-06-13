# frozen_string_literal: true

require 'uri'

class Wx::ServiceController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_weixin_legality
  before_action :parse_xml, only: [:create]
  skip_before_action :check_weixin_legality, on: :config_jssdk
  respond_to :json, :js, :xml
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html
  skip_before_action :authenticate_user, only: :config_jssdk

  layout 'weixin'

  WEIXIN_TOKEN = Settings.weixin.token

  def verify
    p params[:echostr]

    render plain: params[:echostr]
  end

  def create
    case @xml.MsgType
    when 'event'
      p '事件(关注和取消关注等事件)'
      # event_message
      render plain: params[:echostr]
    when 'text'
      text_message
    when 'location' # 用户输入地理位置
      location_message
    end
  end

  def config_jssdk
    # 在rails 5 里面这里绝对不能叫config, 否则 SystemStackError (stack level too deep)
    app_id               =  Settings.wx_pay.app_id
    api_key              =  Settings.wx_pay.api_key
    mch_id               =  Settings.wx_pay.mch_id
    noncestr             =  SecureRandom.hex
    timestamp            =  Time.zone.now.to_i
    url                  =  URI.unescape(params[:url])
    js_sdk_signature_str =  ::WxApp::WxJsSDK.generate_js_sdk_signature_str(noncestr, timestamp, url)
    # 微信 JS 接口签名校验工具
    # https://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=jsapisign
    # invalid signature签名等常见错误
    # 见微信JS-SDK说明文档
    # 附录5-常见错误及解决方法

    Rails.logger.info "jsapi_ticket is #{::WxApp::WxCommon.get_jsapi_ticket}"
    Rails.logger.info "noncestr is #{noncestr}"
    Rails.logger.info "timestamp is #{timestamp}"
    Rails.logger.info "url is #{url}"
    Rails.logger.info "js_sdk_signature_str is #{js_sdk_signature_str}"

    render json: {
      appId: app_id,
      key: api_key,
      mch_id: mch_id,
      timestamp: timestamp,
      nonceStr: noncestr,
      signature: js_sdk_signature_str,
      jsApiList: %w[checkJsApi chooseWXPay chooseImage uploadImage downloadImage previewImage openLocation getLocation]
    }
  end

  private

  def parse_xml
    # munger = defined?(Request::Utils) ? Request::Utils : request
    # data = ActionDispatch::Request::Utils.deep_munge(Hash.from_xml(request.body.read) || {})
    data = Hash.from_xml(request.body.read) || {}

    request.body.rewind if request.body.respond_to?(:rewind)
    data.with_indifferent_access

    if data.present?
      @xml = OpenStruct.new data['xml']
      Rails.logger.info @xml.inspect
    else
      render nothing: true
    end
  end

  # 事件处理
  def event_message
    case @xml.Event
    when 'subscribe' # 新关注用户
      # @invitee = new_user
      # if @xml.EventKey.present?
      #   refer_id = @xml.EventKey.split('_')[1]
      #   @inviter = User.find_by! id: refer_id
      #   begin
      #     invitation = Invitation.create(inviter_id: @inviter.id, invitee_id: @invitee.id, ip_address: request.remote_ip)
      #   rescue Exception => e
      #     p e.message
      #   end
      # end
      render 'wx/service/events/subscribe'
    when 'unsubscribe' # 取关事件
      render 'wx/service/events/unsubscribe'
    # when 'location' # 当用户允许位置获取，微信系统每5秒上报一次地理位置
    #   location_event
    when 'CLICK' # 针对有自定义菜单的公众号
      click_event
    end
  end

  # 自定义菜单事件
  def click_event
    event_key = @xml.EventKey
    case event_key
    when 'contact_us'
      render 'wx/service/events/contact_us'
    when 'feature'
      @items = WxPost.feature.limit(5)
      render 'wx/service/events/posts'
    when 'activity'
      @items = WxPost.activity.limit(5)
      render 'wx/service/events/posts'
    when 'about'
      render 'wx/service/events/subscribe'
    end
  end

  def text_message
    new_user
    case @xml.Content.strip
    when '1'
      render 'wx/service/events/1'
    when '2'
      render 'wx/service/events/2'
    else
      render 'wx/service/events/subscribe'
    end

    # reply = WxReply.find_by keyword: @xml.Content
    # if reply
    #   @text = reply.content
    #   render "wx/service/events/text"
    # end
  end

  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    render(text: 'Forbidden', status: 403) && return unless params[:timestamp] && params[:nonce] && params[:signature]
    array = [WEIXIN_TOKEN, params[:timestamp], params[:nonce]].sort
    render(text: 'Forbidden', status: 403) && return if Digest::SHA1.hexdigest(array.join) != params[:signature]
  end

  def new_user
    @openid = @xml.FromUserName
    authentication = Authentication.where(provider: 'wechat', uid: @openid).first
    if authentication.present?
      @user = authentication.user
    else
      user_info = WxApp::WxCommon.get_user_info @openid
      Rails.logger.info "user_info:::::::::::#{user_info}"
      name = user_info['nickname'].gsub(User::EMOJI_REGEX, '')
      @user = User.new name: (!name.strip.empty? ? name : User.gen_name),
                       # gender:   user_info['sex'],
                       avatar:   user_info['headimgurl'],
                       password: SecureRandom.hex(4)

      @user.gen_slug
      @user.save(validate: false)
      authentication = @user.authentications.build(provider: 'wechat', uid: @openid, unionid: user_info['unionid'])
      authentication.save(validate: false)
    end

    @user
  end
end
