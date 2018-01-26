class Doctors::BaseController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_legality


  protected

  def check_legality
    redirect_to doctors_status_path unless current_user.has_valid_contracts?
  end
end
