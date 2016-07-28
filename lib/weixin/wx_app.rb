module WxApp
  extend self

  WEIXIN_ID = Settings.weixin.app_id
  WEIXIN_SECRET = Settings.weixin.app_secret

  # http://mp.weixin.qq.com/wiki/13/43de8269be54a0a6f64413e4dfa94f39.html
  def create_remote_menus
    conn = get_conn

    p "#{build_menus}"

    conn.post do |req|
      req.url "/cgi-bin/menu/create?access_token=#{get_access_token}"
      req.headers['Content-Type'] = 'application/json'
      req.body = build_menus
    end
  end

  def build_menus
    Jbuilder.encode do |json|
      json.set! :button do
        json.array! WxMenu.all do |menu|
          json.name menu.name

          if menu.wx_sub_menus.present?
            json.set! :sub_button do
              json.array! menu.wx_sub_menus do |sub_menu|
                json.name sub_menu.name
                json.type sub_menu.menu_type
                if sub_menu.menu_type == 'click'
                  json.key  sub_menu.key
                else
                  json.url WxApp.process_url(sub_menu.url)
                end
              end
            end
          else
            json.type menu.menu_type
            if menu.menu_type == 'click'
              json.key  menu.key
            else
              json.url WxApp.process_url(menu.url)
            end
          end
        end
      end
    end
  end

  def self.process_url(url)
    uri = URI.parse(url)

    if Rails.env.development?
      url.gsub!("#{uri.scheme + "://" + uri.host}", Settings.rails_server_url.development)
    else
      url.gsub!("#{uri.scheme + "://" + uri.host}", Settings.rails_server_url.production)
    end
  end

  def get_user_info openid, options={}
    url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{get_access_token}&openid=#{openid}&lang=zh_CN"
    response = Faraday.get url
    body = JSON.parse response.body
    if body['errcode'].blank? && options[:update]
      authentication = Authentication.find_by uid: openid
      if authentication
        authentication.update_column(:unionid, body['unionid']) if authentication.unionid.blank?
        if wx_user = authentication.user
          begin
            name = body['nickname'].gsub(User::EMOJI_REGEX, '')
            wx_user.update_columns name: (name.size > 0 ? name : User.gen_name),
                                   # gender:   body['sex'],
                                   avatar:   body['headimgurl']
          rescue
            Rails.logger.info "update user_info openid:::: #{openid}"
            Rails.logger.info "update user_info body:::: #{body}"
          end
        end
      end
    end
    return body
  end

  def send_template_message message_json
    conn = get_conn
    resp = conn.post do |req|
      req.url "/cgi-bin/message/template/send?access_token=#{get_access_token}"
      req.headers['Content-Type'] = 'application/json'
      req.body = message_json
    end
  end

  def send_cs_message message_json
    conn = get_conn
    resp = conn.post do |req|
      req.url "/cgi-bin/message/custom/send?access_token=#{get_access_token}"
      req.headers['Content-Type'] = 'application/json'
      req.body = message_json
    end
  end

  def get_current_menus
    url = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token=#{get_access_token}"
    response = Faraday.get url
    body = JSON.parse response.body
  end

  # http://mp.weixin.qq.com/wiki/16/ff9b7b85220e1396ffa16794a9d95adc.html
  def load_remote_menus
    p get_current_menus['menu']

    # binding.pry
    menu_arr = get_current_menus['menu']['button']

    WxMenu.destroy_all if menu_arr.present?
    menu_arr.each_with_index do |butn, index|

      if butn['sub_button'].present?
        menu = WxMenu.create butn.except('sub_button').merge(sequence: index)
        butn['sub_button'].each_with_index do |sub_menu, index|
          menu.wx_sub_menus.create sub_menu.except('sub_button', 'type').merge(menu_type: sub_menu['type'], sequence: index)
        end
      else
        menu = WxMenu.create butn.except('sub_button', 'type').merge(menu_type: butn['type'], sequence: index)
      end
    end
  end

  def get_jsapi_ticket
    jsapi_ticket = Rails.cache.fetch("weixin_jsapi_ticket")
    return jsapi_ticket unless jsapi_ticket.nil?

    url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{get_access_token}&type=jsapi"
    response = Faraday.get url
    jsapi_ticket = JSON.parse(response.body)["ticket"]
    Rails.cache.write("weixin_jsapi_ticket", jsapi_ticket, expires_in: 100.minutes)
    return jsapi_ticket
  end

  def get_access_token options={}
    # access_token = Rails.cache.fetch("weixin_access_token")
    # return access_token unless access_token.nil? || options[:force]

    url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{WEIXIN_ID}&secret=#{WEIXIN_SECRET}"
    response = Faraday.get url
    access_token = JSON.parse(response.body)["access_token"]
    # Rails.cache.write("weixin_access_token", access_token, expires_in: 100.minutes)
    return access_token
  end

  def get_qrcode_url user
    resp = qr_limit_scene_ticket user
    ticket = JSON.parse(resp.body)['ticket']
    url = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{URI.encode(ticket)}"
  end

  def qr_limit_scene_ticket user
    scene_id = user.id
    conn = get_conn
    resp = conn.post do |req|
      req.url "/cgi-bin/qrcode/create?access_token=#{get_access_token}"
      req.headers['Content-Type'] = 'application/json'
      req.body = {action_name: "QR_LIMIT_SCENE", action_info: {scene: {scene_id: scene_id}}}.to_json
    end
  end

  def get_conn
    conn = Faraday.new(:url => "https://api.weixin.qq.com/") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end


  # def create_group
  #   # url = "https://api.weixin.qq.com/cgi-bin/groups/create?access_token=#{get_access_token}"
  #   conn = get_conn

  #   p "#{create group}"

  #   conn.post do |req|
  #     req.url = "/cgi-bin/groups/create?access_token=#{get_access_token}"
  #     req.headers['Content-Type'] = 'application/json'
  #     req.body = {"group":{"name":"test"}}
  #   end
  # end
end