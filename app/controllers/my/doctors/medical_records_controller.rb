class My::Doctors::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :check_is_verified_doctor
  before_action :find_reservation
  skip_before_action :find_reservation, except: [:create, :update ]
  skip_before_action :find_reservation, only: [:index ]
  before_action :config_wx_jssdk


  def create
    p medical_record_params
    binding.remote_pry

    create! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      end
    }
  end

  def update
    p medical_record_params
    binding.remote_pry

    resource.medical_record_images.delete_all
    resource.laboratory_examination_images.delete_all
    resource.imaging_examination_images.delete_all

    update! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      end
    }
  end

  def new
    @medical_record ||= MedicalRecord.new
  end

  # def index
  # end

  private

  def begin_of_association_chain
    @user ||= User.find_by(id: params[:id])
  end

  def find_reservation
    reservation_id ||= params[:reservation_id] || medical_record_params[:reservation_id]
    if reservation_id.present?
      @reservation ||= Reservation.find(reservation_id)
    end
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def medical_record_params
    params.require(:medical_record).permit!
    # params.require(:medical_record).permit(medical_record_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
    # params.require(:medical_record).permit(laboratory_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
    # params.require(:medical_record).permit(imaging_examination_images_attributes: [:id, :data, :is_cover, :medica_id, :medical_record_id, :_destroy])
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
