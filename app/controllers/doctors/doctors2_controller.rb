# frozen_string_literal: true

class DoctorsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }

  before_action :check_is_verified_doctor, only: %i[reservations index]
  # skip_before_action :verify_is_doctor, only: :status
  custom_actions collection: %i[reservations status]

  def reservations
    @reservations = current_user.doctor.reservations
  end

  def index; end

  def status; end

  def profile; end

  private

  def check_is_verified_doctor
    if current_user.doctor.nil?
      flash[:error] = '你还没提交资料申请我们的签约医生'
      redirect_to(global_denied_path) && return
    end

    unless current_user.verified_doctor?
      redirect_to(doctors_status_path) && return
    end
  end
end
