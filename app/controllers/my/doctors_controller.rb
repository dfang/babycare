class My::DoctorsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }

  before_action :check_is_verified_doctor, only: [ :reservations, :index ]
  # skip_before_action :verify_is_doctor, only: :status
  custom_actions :collection => [ :reservations, :status ]

  def reservations
    @reservations = current_user.doctor.reservations
  end

  def index
  end

  def status
  end

  def profile
  end

  private

  def check_is_verified_doctor
    binding.pry

    if current_user.doctor.nil?
      flash[:error] = "你还没提交资料申请我们的签约医生"
      redirect_to global_denied_path and return
    end

    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end

end
