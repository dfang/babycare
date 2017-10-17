# frozen_string_literal: true

class PatientsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }
  before_action :deny_doctors!

  def index; end

  def deny_doctors!
    if current_user.verified_doctor?
      flash[:error] = '你是医生, 不能访问用户区域'
      redirect_to global_denied_path and return
    end
  end
end
