# frozen_string_literal: true

class My::HomeController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }
  before_action :check_is_verified_doctor, only: [:index]

  private

  def check_is_verified_doctor
    if current_user.verified_doctor?
      redirect_to(doctors_path) && return
    else
      redirect_to(patients_path) && return
    end
  end
end
