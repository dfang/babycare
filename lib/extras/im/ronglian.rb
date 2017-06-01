#encoding: utf-8

require "base64"
require 'digest/sha1'
require 'httparty'
require 'active_support/callbacks'

module IM
  class Ronglian
    include HTTParty
    include ActiveSupport::Callbacks

    # define_callbacks :call
    # define_callbacks :send_templated_sms
    # set_callback :call, :after, :record_phone_call_history
    # set_callback :send_templated_sms, :after, :record_sms_send_history
    #
    # def record_phone_call_history
    #     p "- record phone call history"
    # end
    #
    # def record_sms_send_history
    #     p "- record sms send history"
    #     RecordSmsSendHistoryJob.perform_now
    # end

    # 预约的时候可以填别的号码
    def call(caller_id, callee_id, reservation_id, caller_phone, callee_phone)
      caller = User.find_by(id: caller_id)
      callee = User.find_by(id: callee_id)
      reservation = Reservation.find_by(id: reservation_id)
      caller_phone = caller_phone || caller.try(:mobile_phone) || caller.doctor.try(:mobile_phone)

      p "caller phone is #{caller_phone}"
      p "callee_phone is #{callee_phone}"

      # callee can nil when call support
      if caller.blank? || reservation.blank?
        raise ActiveRecord::RecordNotFound
      end

      softversion = Settings.ronglian.SoftVersion
      accountsid = Settings.ronglian.AccountSid
      accountauthtoken = Settings.ronglian.AccountAuthToken
      subaccountsid = Settings.ronglian.subAccountSid
      subaccountauthtoken = Settings.ronglian.subAccountAuthToken

      # timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      timestamp = Time.now.strftime("%Y%m%d%H%M%S").to_str()

      sigparameter = Digest::MD5.hexdigest("#{subaccountsid}"+"#{subaccountauthtoken}"+"#{timestamp}").upcase
      authorization = Base64.strict_encode64("#{subaccountsid}:#{timestamp}")

      url = "https://app.cloopen.com:8883/#{softversion}/SubAccounts/#{subaccountsid}/Calls/Callback?sig=#{sigparameter}"

      # http://stackoverflow.com/questions/24691483/passing-headers-and-query-params-in-httparty
      # {
      #   use Authorization => authorization instead of Authorization: authorization
      # }
      HTTParty.post(url,
        body:
          {
            from: caller_phone,
            to:  callee_phone
          }.to_json,
        headers: {
          'Authorization' => authorization,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      )


      RecordPhoneCallHistoryJob.perform_later(caller_id, callee_id, reservation_id, caller_phone, callee_phone)

    end

    def send_templated_sms(to, templateId, *params)
      softversion = Settings.ronglian.SoftVersion
      accountsid = Settings.ronglian.AccountSid
      accountauthtoken = Settings.ronglian.AccountAuthToken
      subaccountsid = Settings.ronglian.subAccountSid
      subaccountauthtoken = Settings.ronglian.subaccountauthtoken
      appid = Settings.ronglian.appid
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")

      sigparameter = Digest::MD5.hexdigest("#{accountsid}"+"#{accountauthtoken}"+"#{timestamp}").upcase
      authorization = Base64.strict_encode64("#{accountsid}:#{timestamp}")

      # Rails.logger.info "accountsid is #{accountsid} \n"
      # Rails.logger.info "timestamp is #{timestamp} \n"
      # Rails.logger.info "sigparameter is #{sigparameter} \n"
      # Rails.logger.info "authorization is #{authorization} \n"

      url = "https://app.cloopen.com:8883/#{softversion}/Accounts/#{accountsid}/SMS/TemplateSMS?sig=#{sigparameter}"

      body = {
        to:  to,
        appId: appid,
        templateId: templateId,
        datas: params.flatten
      }.to_json

      # Use Strings for your hash keys instead of Symbols.
      # otherwise NoMethodError (undefined method `split' for :authorization:Symbol):
      # use => instead of :
      headers = {
        'Authorization' => authorization,
        'Content-Type' => 'application/json;charset=utf-8',
        'Accept' => 'application/json'
      }

      # Rails.logger.info  "sms body is #{body} \n"
      # Rails.logger.info  "headers is #{headers} \n"

      HTTParty.post(url,
        body: body,
        headers: headers
      )

      RecordSmsSendHistoryJob.perform_later(to, templateId)
      # RecordSmsSendHistoryJob.perform_later(sender_user_id, sendee_user_id, sender_phone, sendee_phone, templateId, reservation_id)
    end

  end
end

# require 'uri'
# require 'net/http'

# url = URI("https://api.netease.im/call/ecp/startcall.action")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true
# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# request = Net::HTTP::Post.new(url)

# timestamp = Time.now.getutc.to_i
# nonce = "123456"
# appkey = "3bb9a04dc51d954e8c95d81dc318e335";
# appsecret = "1d3b0a062a8f";
# checksum = Digest::SHA1.hexdigest("#{appsecret}"+"#{nonce}"+"#{timestamp}")

# request["appkey"] = appkey
# request["nonce"] = nonce
# request["curtime"] = timestamp
# request["checksum"] = checksum

# request["content-type"] = 'application/x-www-form-urlencoded'
# request["cache-control"] = 'no-cache'
# request.body = "callerAcc=callmeadoctor&caller=15618903080&callee=18802709638&maxDur=3600"

# response = http.request(request)
# puts response.read_body
