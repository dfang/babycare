class GlobalController < ApplicationController
  def status
  end

  def denied
    @warning = flash[:error]
  end

  def switch
    doctor = Doctor.first
    doctor.user_id = current_user.user_id
    doctor.save

    if doctor.verified?
      doctor.verified = false
    else
      doctor.verified = true
    end

    doctor.save!
  end
end
