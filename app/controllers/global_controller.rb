class GlobalController < ApplicationController
  def status
  end

  def denied
    @warning = flash[:error]
  end

  def switch
    doctor = current_user.doctor.reload

    doctor.user_id = current_user.id
    if doctor.verified?
      doctor.verified = false
    else
      doctor.verified = true
    end
    doctor.save!

    if current_user.doctor && current_user.doctor.verified?
      redirect_to my_doctor_root_path and return
    else
      redirect_to my_patient_root_path and return
    end

  end
end
