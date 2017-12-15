# frozen_string_literal: true

class SimpleCaptcha < ApplicationRecord
  def self.gen_captcha(to)
    captcha = Random.new.rand(100_000...999_999).to_s
    # simple_captcha = SimpleCaptcha.find_by(key: to)

    # 120s
    # 限时120s
    # find_or_create_by()

    simple_captcha = SimpleCaptcha.find_or_create_by(key: to)
    simple_captcha.update!(value: captcha)
    captcha
  end

  def self.captcha_valid?(key, captcha)
    simple_captcha ||= SimpleCaptcha.find_by(key: key).try(:value)
    captcha == simple_captcha
    # cap = SimpleCaptcha.find_by(key: key)
    # if cap && cap.value
    #   simple_captcha = cap.value
    #   captcha == simple_captcha
    # else
    #   false
    # end
  end
end
