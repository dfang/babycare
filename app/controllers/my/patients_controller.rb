class My::PatientsController < InheritedResources::Base
  before_action :authenticate_user!
  custom_actions :collection => [ :reservations, :status ]

  def reservations
    @reservations = current_user.self_reservations
  end

  def index
  end

  def status

  end
end
