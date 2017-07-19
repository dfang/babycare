# frozen_string_literal: true

class Patients::BaseController < InheritedResources::Base
  # FIXIT: 要区分请求端
  before_action :authenticate_request!
  before_action -> { authenticate_user!(force: true) }
  before_action :deny_doctors

  private

  def deny_doctors
    if current_user.verified_doctor?
      # unless resource.user_a == current_user.id
      #   # todo: redirect_to page with permission denied message
      flash[:error] = '你是医生不能访问用户区域'
      redirect_to(global_denied_path) && return
    end
  end
end
