# frozen_string_literal: true

class Doctors::MedicalRecordsController < Doctors::BaseController
  before_action :find_reservation
  # skip_before_action :find_reservation, except: [:create, :update ]
  # skip_before_action :find_reservation, only: [:index ]

  def index
    if @reservation.doctor_user == current_user
      @medical_records = @reservation.family_member.medical_records
    else
      redirect_to global_denied_path
    end
  end

  def create
    p medical_record_params
    create! do
      if @reservation.present?
        doctors_reservation_path(@reservation)
      else
        doctors_medical_record_path(resource)
      end
    end
  end

  def update
    p medical_record_params
    # binding.remote_pry

    # resource.medical_record_images.delete_all
    # resource.laboratory_examination_images.delete_all
    # resource.imaging_examination_images.delete_all

    update! do
      if @reservation.present?
        doctors_reservation_path(@reservation)
      else
        doctors_medical_record_path(resource)
      end
    end
  end

  def new
    @medical_record ||= MedicalRecord.new
  end

  # def index
  # end

  private

  # def begin_of_association_chain
  #   @user ||= User.find_by(id: params[:id])
  # end

  def find_reservation
    Rails.logger.info 'find_reservation'
    reservation_id ||= params[:reservation_id] || medical_record_params[:reservation_id]
    @reservation ||= Reservation.find(reservation_id) if reservation_id.present?
  end

  # def medical_record_params
  # params.require(:medical_record).permit!
  # params.require(:medical_record).permit(medical_record_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
  # params.require(:medical_record).permit(laboratory_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
  # params.require(:medical_record).permit(imaging_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
  # end

  def medical_record_params
    params.require(:medical_record).permit(
      :create_date, :write_date, :weight, :laboratory_and_supplementary_examinations, :updated_at,
      :pulse, :height, :diastolic_pressure, :systolic_pressure, :chief_complaint, :vaccination_history, :personal_history,
      :family_history, :user_id, :temperature, :pain_score, :bmi, :physical_examination, :respiratory_rate,
      :onset_date, :remarks, :history_of_present_illness, :past_medical_history, :allergic_history,
      :preliminary_diagnosis, :treatment_recommendation, :imaging_examination, :created_at,
      :oxygen_saturation, :reservation_id, :blood_type, :date_of_birth, :name, :gender, :identity_card,
      medical_record_images_attributes: %i[id data media_id _destroy],
      laboratory_examination_images_attributes: %i[id data media_id _destroy],
      imaging_examination_images_attributes: %i[id data media_id _destroy]
    )
  end
end
