class SimpleCaptcha < ApplicationRecord

  def self.gen_captcha(to)
    captcha = Random.new.rand(000000...999999).to_s
    simple_captcha = SimpleCaptcha.find_by(key: to)
    if simple_captcha.blank?
      simple_captcha = SimpleCaptcha.new(key: to, value: captcha)
    else
      simple_captcha.value = captcha
    end
    simple_captcha.save!
    captcha
  end

  def captcha_valid?(key, captcha)
    simple_captcha ||= SimpleCaptcha.find_by(key: key).value
    captcha == simple_captcha
  end
end
