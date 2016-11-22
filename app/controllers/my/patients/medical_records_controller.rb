class My::Patients::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_reservation, only: [:create, :update]
  skip_before_action :find_reservation, except: [:create, :update]
  before_action :config_wx_jssdk, only: [:new, :edit]

  def index
    @medical_records = current_user.medical_records.order('created_at DESC')
  end

  def create
    create! {
      if @reservation.present?
        my_patients_reservation_path(@reservation)
      else
        my_patients_profile_path
      end
    }
  end

  def update
    # resource.medical_record_images.delete_all
    # resource.laboratory_examination_images.delete_all
    # resource.imaging_examination_images.delete_all

    p medical_record_params
    # binding.remote_pry

    update! {
      if @reservation.present?
        my_patients_reservation_path(@reservation)
      else
        my_patients_profile_path
      end
    }
  end

  def status
  end

  def show
  end

  def new
    @medical_record ||= MedicalRecord.new
    if params.key?(:reservation_id)
      reservation = Reservation.find_by(id: params[:reservation_id])
      @medical_record.name = reservation.reservation_phone
    end

    @medical_record.blood_type = current_user.settings.first.try(:blood_type)
    @medical_record.birthdate = current_user.settings.first.try(:birthdate)
    @medical_record.gender = current_user.settings.first.try(:gender)
    @medical_record.history_of_present_illness = current_user.settings.first.try(:history_of_present_illness)
    @medical_record.past_medical_history = current_user.settings.first.try(:past_medical_history)
    @medical_record.allergic_history = current_user.settings.first.try(:allergic_history)
    @medical_record.personal_history = current_user.settings.first.try(:personal_history)
    @medical_record.family_history = current_user.settings.first.try(:family_history)
    @medical_record.vaccination_history = current_user.settings.first.try(:vaccination_history)
  end

  private

  # def begin_of_association_chain
  #   current_user
  # end

  def find_reservation
    reservation_id ||= params[:reservation_id] || medical_record_params[:reservation_id]
    if reservation_id.present?
      @reservation ||= Reservation.find(reservation_id)
    end
  end

  def medical_record_params
    params.require(:medical_record).permit!
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
