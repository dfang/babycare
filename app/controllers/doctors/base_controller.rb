# frozen_string_literal: true

class Doctors::BaseController < InheritedResources::Base
  helper_method :current_doctor
  before_action :authenticate_user!
  before_action :check_legality

  protected

  def check_legality
    redirect_to doctors_status_path unless current_doctor && current_doctor.has_valid_contracts?
  end

  def current_doctor
    @current_doctor ||= current_user.doctor if current_user.doctor.present?
  end
end
