require 'uri'

class Wx::ServiceController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_weixin_legality
  before_action :parse_xml, only: [:create]
  respond_to :json, :js, :xml

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
      event_message
    when 'text'
      text_message
    when 'location' # 用户输入地理位置
      location_message
    end
  end

  def config_jssdk
    # 在rails 5 里面这里绝对不能叫config, 否则 SystemStackError (stack level too deep)
    appId           =  Settings.wx_pay.app_id
    nonceStr        =  SecureRandom.hex
    timestamp       =  DateTime.now.to_i

    js_sdk_signature_str       =  ::WxApp::WxPay.generate_js_sdk_signature_str(nonceStr, timestamp,  URI.unescape(params[:url]))
    p js_sdk_signature_str

    render json: {
        appId: appId,
        key: Settings.wx_pay.api_key,
        mch_id: Settings.wx_pay.mch_id,
        timestamp: timestamp.to_s,
        nonceStr: nonceStr,
        signature: js_sdk_signature_str,
        jsApiList: ['checkJsApi', 'chooseWXPay', 'chooseImage', 'uploadImage', 'downloadImage', 'previewImage', 'openLocation', 'getLocation']
      }
  end

private

  def parse_xml
    # munger = defined?(Request::Utils) ? Request::Utils : request
    data = ActionDispatch::Request::Utils.deep_munge(Hash.from_xml(request.body.read) || {})

    request.body.rewind if request.body.respond_to?(:rewind)
    data.with_indifferent_access

    if data.present?
      @xml = OpenStruct.new data['xml']
      Rails.logger.info @xml.inspect
    else
      render nothing: true
    end
  end

  #事件处理
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

  #自定义菜单事件
  def click_event
    event_key = @xml.EventKey
    case event_key
    when 'contact_us'
      render "wx/service/events/contact_us"
    when 'feature'
      @items = WxPost.feature.limit(5)
      render "wx/service/events/posts"
    when 'activity'
      @items = WxPost.activity.limit(5)
      render "wx/service/events/posts"
    when 'about'
      render "wx/service/events/subscribe"
    end
  end

  def text_message
    new_user
    case @xml.Content.strip
    when '1'
      render "wx/service/events/1"
    when '2'
      render "wx/service/events/2"
    else
      render "wx/service/events/subscribe"
    end

    # reply = WxReply.find_by keyword: @xml.Content
    # if reply
    #   @text = reply.content
    #   render "wx/service/events/text"
    # end
  end

  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    render :text => "Forbidden", :status => 403 and return unless params[:timestamp] && params[:nonce] && params[:signature]
    array = [WEIXIN_TOKEN, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 and return if Digest::SHA1.hexdigest(array.join) != params[:signature]
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
      @user = User.new name: (name.strip.size > 0 ? name : User.gen_name),
                       # gender:   user_info['sex'],
                       avatar:   user_info['headimgurl'],
                       password: SecureRandom.hex(4)

      @user.gen_slug
      @user.save(validate: false)
      authentication = @user.authentications.build(provider: 'wechat', uid: @openid, unionid: user_info['unionid'])
      authentication.save(validate: false)
    end

    return @user
  end
end
