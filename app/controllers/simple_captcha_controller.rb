class SimpleCaptchaController < ApplicationController

  def request_captcha
    return unless params.key?(:mobile_phone)
    to = params[:mobile_phone]
    Rails.logger.info to
    # 生出验证码, 记录到数据库
    captcha = SimpleCaptcha.gen_captcha(to)

    # 发出去
    # SmsCaptchaJob.perform_now(to, captcha)
  end

  # 验证验证码是否正确
  def simple_captcha_valid
    return unless params.key?(:mobile_phone) && params.key?(:captcha)

    key = params[:mobile_phone]
    captcha = params[:captcha]

    if SimpleCaptcha.captcha_valid?(key, captcha)
      Rails.logger.info "验证成功"
      render :json => {"result": "success"}
    else
      Rails.logger.info "验证失败"
      render :json => {"result": "failed"}
    end
  end
end
