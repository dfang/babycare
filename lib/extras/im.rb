require 'digest/sha1' 
require 'httparty'

class IM
  include HTTParty
  
  # def initialize()
  #   @appkey = Settings.im.appkey
  #   @appsecret = Settings.im.appsecret
  # end

  def self.call(caller, callee)
    url = 'https://api.netease.im/call/ecp/startcall.action'
    @appkey = Settings.im.appkey
    @appsecret = Settings.im.appsecret

    p @appkey
    nonce = Random.rand(100000000000000000)
    timestamp = Time.now.getutc.to_i
    checksum = Digest::SHA1.hexdigest("#{@appsecret}"+"#{nonce}"+"#{timestamp}")

    HTTParty.post(url, 
      body:
        { 
          callerAcc: "xyzzyx",
          caller:  caller,
          callee:  callee,
          maxDur:  3600 
        },
      headers: { 
        'AppKey': @appkey.to_s,
        'Nonce': nonce.to_s,
        'CurTime': timestamp.to_s,
        'CheckSum': checksum.to_s,
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8', 
        'Accept': 'application/json'
      }
    )
  end


  def self.send_sms(mobile, code)
    mobile = '15618903080'
    code = (0...6).map { (65 + rand(26)).chr }.join
    url = 'https://api.netease.im/sms/sendcode.action'
    @appkey = Settings.im.appkey
    @appsecret = Settings.im.appsecret

    nonce = Random.rand(100000000000000000)
    timestamp = Time.now.getutc.to_i
    checksum = Digest::SHA1.hexdigest("#{@appsecret}"+"#{nonce}"+"#{timestamp}")

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
      }
    )
  end

  def send_templated_sms(template_id, mobiles, parameters)
    url = 'https://api.netease.im/sms/sendtemplate.action'
    
    @appkey = Settings.im.appkey
    @appsecret = Settings.im.appsecret

    nonce = Random.rand(100000000000000000)
    timestamp = Time.now.getutc.to_i
    checksum = Digest::SHA1.hexdigest("#{@appsecret}"+"#{nonce}"+"#{timestamp}")

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
      }
    )
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