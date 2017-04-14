class My::Doctors::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :check_is_verified_doctor
  before_action :config_wx_jssdk, only: [:new, :edit]
  # before_action :find_reservation
  # skip_before_action :find_reservation, except: [:create, :update ]
  # skip_before_action :find_reservation, only: [:index ]

  def create
    p medical_record_params
    # binding.remote_pry
    create! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      else
        my_doctors_medical_record_path(resource)
      end
    }
  end

  def update
    p medical_record_params
    # binding.remote_pry

    # resource.medical_record_images.delete_all
    # resource.laboratory_examination_images.delete_all
    # resource.imaging_examination_images.delete_all

    update! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      else
        my_doctors_medical_record_path(resource)
      end
    }
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

  # def find_reservation
  #   Rails.logger.info "find_reservation"
  #   reservation_id ||= params[:reservation_id] || medical_record_params[:reservation_id]
  #   if reservation_id.present?
  #     @reservation ||= Reservation.find(reservation_id)
  #   end
  # end

  # def medical_record_params
    # params.require(:medical_record).permit!
    # params.require(:medical_record).permit(medical_record_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
    # params.require(:medical_record).permit(laboratory_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
    # params.require(:medical_record).permit(imaging_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
  # end

  def medical_record_params
    params.require(:medical_record).permit(
      :create_date, :write_date, :weight, :laboratory_and_supplementary_examinations, :updated_at,
      :pulse, :height, :blood_pressure, :chief_complaint, :vaccination_history, :personal_history,
      :family_history, :user_id, :temperature, :pain_score, :bmi, :physical_examination, :respiratory_rate,
      :onset_date, :remarks, :history_of_present_illness, :past_medical_history, :allergic_history,
      :preliminary_diagnosis, :treatment_recommendation, :imaging_examination, :created_at,
      :oxygen_saturation, :reservation_id, :blood_type, :date_of_birth, :name, :gender, :identity_card,
      medical_record_images_attributes: [ :id, :data, :media_id, :_destroy],
      laboratory_examination_images_attributes: [ :id, :data, :media_id, :_destroy],
      imaging_examination_images_attributes: [ :id, :data, :media_id, :_destroy]
    )
  end

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end

  def config_wx_jssdk
    @appId = Settings.wx_pay.app_id
    @nonceStr = SecureRandom.hex
    @timestamp =  DateTime.now.to_i
    js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: @nonceStr, timestamp: @timestamp, url: request.url }.sort.map do |k,v|
                        "#{k}=#{v}" if v != "" && !v.nil?
                      end.compact.join('&')
    @signature = Digest::SHA1.hexdigest(js_sdk_signature_str)
  end
end
