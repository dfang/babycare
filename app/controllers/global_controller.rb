# frozen_string_literal: true

class GlobalController < ApplicationController
  def status; end

  def denied
    @warning = flash[:error]
  end

  def switch
    doctor ||= if current_user.doctor.present?
                 current_user.doctor.reload
               else
                 Doctor.first
               end

    doctor.reload
    doctor.user_id = current_user.id
    doctor.verified = if doctor.verified?
                        false
                      else
                        true
                      end
    doctor.save!

    if current_user.doctor && current_user.doctor.verified?
      redirect_to(my_doctor_root_path) && return
    else
      redirect_to(my_patient_root_path) && return
    end
  end
end
