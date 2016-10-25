class GlobalController < ApplicationController
  def status
  end

  def denied
    @warning = flash[:error]
  end

  def switch
    doctor = Doctor.first.reload
    doctor.user_id = current_user.id
    doctor.verified = !doctor.verified?
    doctor.save!

    if current_user.is_verified_doctor?
      redirect_to my_doctor_root_path and return
    else
      redirect_to my_patient_root_path and return
    end

  end
end
