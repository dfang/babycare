# frozen_string_literal: true

class Patients::SettingsController < Patients::BaseController
  def edit; end

  protected

  def setting_params
    params.require(:setting).permit!
  end
end
