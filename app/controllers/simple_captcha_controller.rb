class SimpleCaptchaController < ApplicationController
  def request_captcha
    # 把验证码发出去
    return unless params.key?(:mobile_phone)
    to = params[:mobile_phone]
    Rails.logger.info to
    # 生出验证码, 记录到数据库
    captcha = SimpleCaptcha.gen_captcha(to)

    # 发出去
    # SmsCaptchaJob.perform_now(to, captcha)
  end

  def simple_captcha_valid
    # 验证验证码是否正确
    return unless params.key?(:mobile_phone)
    key = params[:mobile_phone]
    captcha = params[:captcha]
    if SimpleCaptcha.aptcha_valid?(key, captcha)
      Rails.logger.info "验证失败"
    else
      Rails.logger.info "验证成功"
    end
  end
end
