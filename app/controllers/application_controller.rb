require 'browser'
require "#{Rails.root}/lib/extras/browser"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :detect_platform
  before_action :complete_profile
  # before_action :complete_profile

  layout proc { |controller| controller.request.xhr? ? false : 'application' }
  helper_method :body_class


  def body_class
    @body_class || "#{params[:controller]}-#{params[:action]}"
  end

  def detect_platform
    browser = Browser.new(request.user_agent)
    if browser.platform.mac? || browser.platform.linux? || browser.platform.windows?
      @is_desktop = true
      @is_mobile = false
      request.variant = :phone
    else
      @is_mobile = true
      @is_desktop = false
      request.variant = :phone
    end
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def complete_profile

  end
end
