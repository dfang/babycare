class My::DoctorsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :verify_is_doctor
  before_action :verify_is_verified_doctor

  custom_actions :collection => :reservations
  
  def reservations
    if current_user.is_verified_doctor?
      @reservations = current_user.doctor.reservations
    else
      @reservations = []
    end
  end

  private

  def verify_is_doctor
    if current_user.is_doctor?

    else
      
    end
  end

  def verify_is_verified_doctor
    
  end

end
