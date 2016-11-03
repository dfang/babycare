class My::Patients::SettingsController < InheritedResources::Base

  def new
  end

  def edit
    @resource = current_user.settings.first || Setting.new
  end

  def show
  end

  def update
    if current_user.settings.present?
      setting = current_user.settings.first
    else
      setting = current_user.settings.build
    end
    setting.update(setting_params)
    redirect_to my_patients_settings_path
  end

  protected

  def setting_params
    params.require(:setting).permit!
  end

end
