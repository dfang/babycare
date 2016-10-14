class My::Patients::SettingsController < InheritedResources::Base

  def new
  end

  def edit
    @resource = current_user.settings.first || Setting.new
  end

  def show
  end

  def update
    setting = current_user.settings.first
    setting.update(setting_params)
    redirect_to my_patients_settings_path
  end

  protected

  def setting_params
    params.require(:setting).permit!
  end

end
