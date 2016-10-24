class GlobalController < ApplicationController
  def status
  end

  def denied
    @warning = flash[:error]
  end

  def switch
    doctor = Doctor.first
    doctor.user_id = current_user.id
    doctor.save

    if doctor.verified?
      doctor.verified = false
    else
      doctor.verified = true
    end

    doctor.save!

    if current_user.is_verified_doctor?
      redirect_to my_doctor_root_path and return
    else
      redirect_to my_patient_root_path and return
    end

  end
end
