# frozen_string_literal: true

class My::PatientsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }

  before_action :check_is_verified_doctor
  skip_before_action :check_is_verified_doctor, only: [:status]
  custom_actions collection: %i[reservations status profile]

  def reservations
    @reservations = current_user.reservations
  end

  def index; end

  def status; end

  def profile; end

  private

  def check_is_verified_doctor
    redirect_to(patients_status_path) && return if current_user.verified_doctor?
  end
end
