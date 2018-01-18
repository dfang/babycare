# frozen_string_literal: true

module WxApp
  module WxCommon
    extend self

    WEIXIN_ID = Settings.mp.app_id
    WEIXIN_SECRET = Settings.mp.app_secret

    def get_conn
      conn = Faraday.new(url: 'https://api.weixin.qq.com/') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get_access_token(_options = {})
      Rails.logger.info 'begin get_access_token .......'
      Rails.cache.fetch 'weixin_access_token', expires_in: 7000.seconds do
        begin
          url = "/cgi-bin/token?grant_type=client_credential&appid=#{WEIXIN_ID}&secret=#{WEIXIN_SECRET}"
          conn = get_conn
          response = conn.get url
        # url = (ENV['WX_ACCESS_TOKEN_URL']).to_s || 'localhost:8080'
        # response = Faraday.new.get(url)
          json = JSON.parse(response.body)
          Rails.logger.info(json)
          raise json['errmsg'] if(json['errcode']).present?
          access_token = json['access_token']
        rescue => e
          Rails.logger.error e.message
          Rollbar.error(e)
        end
      end
    end

    def get_jsapi_ticket
      Rails.logger.info 'begin get_jsapi_ticket .......'
      Rails.cache.fetch 'jsapi_ticket', expires_in: 7000.seconds do
        begin
          url = "/cgi-bin/ticket/getticket?access_token=#{WxApp::WxCommon.get_access_token}&type=jsapi"
          Rails.logger.info "url is #{url}"
          conn = get_conn
          response = conn.get url
          json = JSON.parse(response.body)
          Rails.logger.info "get_jsapi_ticket response body is: \n#{json}"
          raise json['errmsg'] if(json['errcode']) > 0
          jsapi_ticket = json['ticket']
        rescue => e
          Rails.logger.error e.message
          Rollbar.error(e)
        end
      end
    end
  end
end

module WxApp
  module WxButton
    include WxApp::WxCommon
    extend self

    # http://mp.weixin.qq.com/wiki/13/43de8269be54a0a6f64413e4dfa94f39.html
    def create_remote_menus(menus)
      conn = get_conn

      p build_menus.to_s
      p 'syncing menus to remote'
      conn.post do |req|
        req.url "/cgi-bin/menu/create?access_token=#{WxApp::WxCommon.get_access_token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = menus
      end
    end

    # FIXME
    # rubocop:disable Metrics/MethodLength
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
                    json.key sub_menu.key
                  else
                    json.url WxApp::WxButton.process_url(sub_menu.url)
                    # json.url sub_menu.url
                  end
                end
              end
            else
              json.type menu.menu_type
              if menu.menu_type == 'click'
                json.key menu.key
              else
                # json.url menu.url
                json.url WxApp::WxButton.process_url(menu.url)
              end
            end
          end
        end
      end
    end

    def process_url(url)
      uri = URI.parse(url)
      if Rails.env.development?
        url.gsub!((uri.scheme + '://' + uri.host).to_s, Settings.rails_server_url.development)
      else
        url.gsub!((uri.scheme + '://' + uri.host).to_s, Settings.rails_server_url.production)
      end
    end

    def get_user_info(openid, options = {})
      url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{WxApp::WxCommon.get_access_token}&openid=#{openid}&lang=zh_CN"
      response = Faraday.get url
      body = JSON.parse response.body
      if body['errcode'].blank? && options[:update]
        authentication = Authentication.find_by uid: openid
        if authentication
          authentication.update_column(:unionid, body['unionid']) if authentication.unionid.blank?
          if wx_user = authentication.user
            begin
              name = body['nickname'].gsub(User::EMOJI_REGEX, '')
              wx_user.update_columns name: (!name.empty? ? name : User.gen_name),
                                     # gender:   body['sex'],
                                     avatar:   body['headimgurl']
            rescue
              Rails.logger.info "update user_info openid:::: #{openid}"
              Rails.logger.info "update user_info body:::: #{body}"
            end
          end
        end
      end
      body
    end

    def send_template_message(message_json)
      conn = get_conn
      resp = conn.post do |req|
        req.url "/cgi-bin/message/template/send?access_token=#{WxApp::WxCommon.get_access_token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = message_json
      end
    end

    def send_cs_message(message_json)
      conn = get_conn
      resp = conn.post do |req|
        req.url "/cgi-bin/message/custom/send?access_token=#{WxApp::WxCommon.get_access_token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = message_json
      end
    end

    def get_current_menus
      url = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token=#{WxApp::WxCommon.get_access_token}"
      response = Faraday.get url
      body = JSON.parse response.body
    end

    # http://mp.weixin.qq.com/wiki/16/ff9b7b85220e1396ffa16794a9d95adc.html
    def load_remote_menus
      p get_current_menus['menu']

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

    def get_qrcode_url(user)
      resp = qr_limit_scene_ticket user
      ticket = JSON.parse(resp.body)['ticket']
      url = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{URI.encode(ticket)}"
    end

    def qr_limit_scene_ticket(user)
      scene_id = user.id
      conn = get_conn
      resp = conn.post do |req|
        req.url "/cgi-bin/qrcode/create?access_token=#{WxApp::WxCommon.get_access_token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { action_name: 'QR_LIMIT_SCENE', action_info: { scene: { scene_id: scene_id } } }.to_json
      end
    end

    # def create_group
    #   # url = "https://api.weixin.qq.com/cgi-bin/groups/create?access_token=#{WxApp::WxCommon.get_access_token}"
    #   conn = get_conn

    #   p "#{create group}"

    #   conn.post do |req|
    #     req.url = "/cgi-bin/groups/create?access_token=#{WxApp::WxCommon.get_access_token}"
    #     req.headers['Content-Type'] = 'application/json'
    #     req.body = {"group":{"name":"test"}}
    #   end
    # end
  end
end

module WxApp
  module WxJsSDK
    extend self

    def generate_payment_params(body_text, out_trade_no, fee, ip, notify_url, trade_type)
      payment_params = {
        body: body_text,
        out_trade_no: out_trade_no,
        total_fee: fee,
        spbill_create_ip: ip,
        notify_url: notify_url,
        trade_type: trade_type
      }
      payment_params
    end

    def generate_payment_options(options = {})
      options = {
        appid:     Settings.wx_pay.app_id,
        mch_id:    Settings.wx_pay.mch_id,
        key:       Settings.wx_pay.api_key,
        noncestr:  SecureRandom.hex,
        timestamp: Time.zone.now.to_i
      }.merge(options)
      options
    end

    def generate_js_sdk_signature_str(noncestr, timestamp, url)
      Rails.logger.info "jsapi_ticket is #{::WxApp::WxCommon.get_jsapi_ticket}"
      js_sdk_signature_str = { jsapi_ticket: ::WxApp::WxCommon.get_jsapi_ticket, noncestr: noncestr, timestamp: timestamp, url: url }.sort.map do |k, v|
        "#{k}=#{v}" if v != '' && !v.nil?
      end.compact.join('&')
      Digest::SHA1.hexdigest(js_sdk_signature_str)
    end

    # generate paysign sort, and encrypt
    def generate_pay_sign_str(options, prepay_id)
      # options = generate_payment_options 这样会出错， 需要共用options

      # 这里不能用options[:app_id]和 options[:key], 因为WxPay::Service.invoke_unifiedorder会delete掉，详情要查看源码,这里用result['appid']或Settings.wx_pay.app_id都可以
      pay_sign_str = {
        appId:      Settings.wx_pay.app_id,
        nonceStr:   options[:noncestr],
        timeStamp:  options[:timestamp],
        package:    "prepay_id=#{prepay_id}",
        signType:   'MD5'
      }.sort.map do |k, v|
        "#{k}=#{v}" if v != '' && !v.nil?
      end.compact.join('&').concat("&key=#{Settings.wx_pay.key}")

      Digest::MD5.hexdigest(pay_sign_str).upcase
    end

    def pay_to_wechat_user(openid, amount, _ip)
      # check_required_options(params, GENERATE_APP_PAY_REQ_REQUIRED_FIELDS)
      # partner_trade_no = "withdraw_#{Time.zone.now.strftime('%Y%m%d')}_#{SecureRandom.random_number(100000)}"

      # ip                = "127.0.0.1"
      # openid = "ox-t3s08e-Av2rUlE2a2i2ITR0XY"
      # amount = 100
      partner_trade_no  = "withdraw_#{Time.zone.now.strftime('%Y%m%d')}#{SecureRandom.random_number(100_000)}"
      re_user_name      = ''

      transfer_params = {
        mch_appid:           Settings.wx_pay.app_id,
        partner_trade_no:    partner_trade_no,
        openid:              openid,
        check_name:          'NO_CHECK',
        spbill_create_ip:    '127.0.0.1',
        desc:                '提现',
        amount:              amount
      }
      options = ::WxApp::WxJsSDK.generate_payment_options
      ::WxPay::Service.invoke_transfer(transfer_params, options)

      # WxPay::Service.send(:make_payload, transfer_params)
      # WxPay::Sign.generate(transfer_params)
      # WxPay::Sign.verify?(transfer_params)
    end
  end
end
