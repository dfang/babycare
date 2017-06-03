# encoding: utf-8
# frozen_string_literal: true

require 'base64'
require 'digest/sha1'
require 'httparty'
require 'active_support/callbacks'

module IM
  class Netease
    include HTTParty

    # 文档地址 http://dev.netease.im/docs?doc=server_call
    def self.call(caller_phone, callee_phone, _caller_id, _callee_id, _reservation_id)
      url = 'https://api.netease.im/call/ecp/startcall.action'
      @appkey = Settings.im.appkey
      @appsecret = Settings.im.appsecret

      p @appkey
      nonce = Random.rand(100_000_000_000_000_000)
      timestamp = Time.now.getutc.to_i
      checksum = Digest::SHA1.hexdigest(@appsecret.to_s + nonce.to_s + timestamp.to_s)

      HTTParty.post(url,
                    body:
                      {
                        callerAcc: 'xyzzyx',
                        caller:  caller_phone,
                        callee:  callee_phone,
                        maxDur:  3600
                      },
                    headers: {
                      'AppKey' => @appkey.to_s,
                      'Nonce' => nonce.to_s,
                      'CurTime' => timestamp.to_s,
                      'CheckSum' => checksum.to_s,
                      'Content-Type' => 'application/x-www-form-urlencoded;charset=utf-8',
                      'Accept' => 'application/json'
                    })
    end

    def self.send_sms(mobile, _code)
      mobile = '15618903080'
      code = (0...6).map { (65 + rand(26)).chr }.join
      url = 'https://api.netease.im/sms/sendcode.action'
      @appkey = Settings.im.appkey
      @appsecret = Settings.im.appsecret

      nonce = Random.rand(100_000_000_000_000_000)
      timestamp = Time.now.getutc.to_i
      checksum = Digest::SHA1.hexdigest(@appsecret.to_s + nonce.to_s + timestamp.to_s)

      HTTParty.post(url,
                    body:
                      {
                        mobile: mobile
                      },
                    headers: {
                      'AppKey': @appkey.to_s,
                      'Nonce': nonce.to_s,
                      'CurTime': timestamp.to_s,
                      'CheckSum': checksum.to_s,
                      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
                      'Accept': 'application/json'
                    })
    end

    def send_templated_sms(template_id, _mobiles, _parameters)
      url = 'https://api.netease.im/sms/sendtemplate.action'

      @appkey = Settings.im.appkey
      @appsecret = Settings.im.appsecret

      nonce = Random.rand(100_000_000_000_000_000)
      timestamp = Time.now.getutc.to_i
      checksum = Digest::SHA1.hexdigest(@appsecret.to_s + nonce.to_s + timestamp.to_s)

      HTTParty.post(url,
                    body:
                      {
                        template_id: template_id,
                        mobiles: [''],
                        params: ['', '']
                      },
                    headers: {
                      'AppKey': @appkey.to_s,
                      'Nonce': nonce.to_s,
                      'CurTime': timestamp.to_s,
                      'CheckSum': checksum.to_s,
                      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
                      'Accept': 'application/json'
                    })
    end
  end
end
