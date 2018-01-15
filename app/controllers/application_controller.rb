# frozen_string_literal: true

require 'browser'

class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, only: :current_wechat_authentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :detect_platform
  before_action :complete_profile
  # before_action :complete_profile
  before_action :prepare_exception_notifier

  layout proc { |controller| controller.request.xhr? ? false : 'application' }
  helper_method :body_class

  def body_class
    @body_class || "#{params[:controller]}-#{params[:action]}"
  end

  def detect_platform
    @browser = Browser.new(request.user_agent)
    # if browser.platform.mac? || browser.platform.linux? || browser.platform.windows?
    #   @is_desktop = true
    #   @is_mobile = false
    # else
    #   @is_mobile = true
    #   @is_desktop = false
    #   request.variant = :phone
    # end
    Rails.logger.info 'browser info from user agent'
    Rails.logger.info request.user_agent
    Rails.logger.info "device: #{@browser.device.name}"
    Rails.logger.info "platform: #{@browser.platform.name}-#{@browser.platform.version}"
    Rails.logger.info "platform: #{@browser.full_version}"
    Rails.logger.info "browser: #{@browser.name}-#{@browser.version}"
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def complete_profile; end

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: current_user
    }
  end

  protected

  def authenticate_request!
    unless unionid_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    authentication = Authentication.find_by(unionid: auth_token[:unionid])
    @current_user = authentication.user
    Rails.logger.info 'sign innnnnn'

    sign_in(@current_user)
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private

  def web_token
    @web_token ||=  if request.headers['Authorization'].present?
                      request.headers['Authorization'].split(' ').last
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(web_token)
  end

  def unionid_in_token?
    web_token && auth_token && auth_token[:unionid]
  end
end
