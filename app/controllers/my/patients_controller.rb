class My::PatientsController < InheritedResources::Base
  before_action :authenticate_user!

  custom_actions :collection => :reservations

  def reservations
    @reservations = current_user.self_reservations
  end

  def index
  end

end
