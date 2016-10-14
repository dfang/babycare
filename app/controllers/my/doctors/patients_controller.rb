class My::Doctors::PatientsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_user

  def profile

  end

  private

  def find_user
    user ||= User.find_by(id: params[:id])
  end
end
