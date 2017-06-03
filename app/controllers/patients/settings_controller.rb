# frozen_string_literal: true

class Patients::SettingsController < InheritedResources::Base
  def edit; end

  protected

  def setting_params
    params.require(:setting).permit!
  end
end
