# frozen_string_literal: true

require 'rqrcode'

class UsersController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }
  before_action :gen_qrcode, only: [:qrcode]

  # /users/:id/qrcode 用户打开这个页面让医生扫描
  def qrcode
    @qrcode = current_user.qrcode_url
  end

  # /users/:id/scan_qrcode 医生扫描后进入这个页面
  def scan_qrcode
    user = User.find_by(id: params[:id])
    # latest_reservation = user.reservations.where(user_b: current_user.id).order('created_at DESC').first
    if current_user.doctor?
      @reservation = Reservation.where(doctor_id: current_user.doctor.id).where(user: user).order('updated_at DESC').first
      if @reservation.present?
        @reservation.scan_qrcode! if @reservation.to_consult?

        redirect_to(doctors_reservation_path(@reservation)) && return
      else
        raise StandardError
      end

    else
      redirect_to(global_denied_path) && return
    end
  end

  def children; end

  private

  def gen_qrcode
    current_user.save_qrcode! if current_user.qrcode_url.blank?
  end
end
