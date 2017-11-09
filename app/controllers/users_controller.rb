# frozen_string_literal: true

require 'rqrcode'

class UsersController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }

  # /users/:id/qrcode 用户打开这个页面让医生扫描
  def qrcode
    @qrcode = current_user.qrcode_url
  end

  # /users/:id/scan_qrcode 医生扫描后进入这个页面
  def scan_qrcode
    user = User.find_by(id: params[:id])
    # latest_reservation = user.reservations.where(user_b: current_user.id).order('created_at DESC').first
    if current_user.doctor?
      redirect_to profile_doctors_patient_path(user)
    else
      redirect_to(global_denied_path) && return
    end
  end

  def children; end
end
