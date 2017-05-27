class Patients::SettingsController < InheritedResources::Base

  def new
  end

  def edit
  end

  def show
  end

  def update
    # if current_user.settings.present?
    #   setting = current_user.settings.first
    # else
    #   setting = current_user.settings.build
    # end
    # setting.update(setting_params)
    binding.pry
    redirect_to patients_index_path and return
  end

  protected

  def setting_params
    params.require(:setting).permit!
  end

end
