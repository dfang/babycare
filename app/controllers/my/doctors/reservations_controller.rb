class My::Doctors::ReservationsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ], :member => [ :claim, :complete_offline_consult, :complete_online_consult ]

  def reservations
  end

  def index
    p params
    if params.key?(:id)
      # /my/doctors/patients/22/reservations
      # {"controller"=>"my/doctors/reservations", "action"=>"index", "id"=>"22"}
      # 医生查看某病人和自己的所有的预约页面
      @user = User.find_by(id: params[:id])
      @reservations = @user.reservations.order("updated_at DESC")
    else
      # /my/doctors/reservations
      # {"controller"=>"my/doctors/reservations", "action"=>"index"}
      # 医生的所有预约页面
      @reservations = current_user.reservations.order("updated_at DESC")
    end
  end

  def show
    # /my/doctors/reservations/106
    # {"controller"=>"my/doctors/reservations", "action"=>"show", "id"=>"106"}
    super
  end

  def detail
  end

  def status
  end

  # 医生认领用户的预约
  def claim
    if request.put?
      resource.update(reservation_params)
      resource.user_b = current_user.id

      resource.reserve!

      redirect_to my_doctors_reservation_path(resource) and return
    else
      @appId = Settings.wx_pay.app_id
      @nonceStr = SecureRandom.hex
      @timestamp =  DateTime.now.to_i
      js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: @nonceStr, timestamp: @timestamp, url: request.url }.sort.map do |k,v|
                          "#{k}=#{v}" if v != "" && !v.nil?
                        end.compact.join('&')
      @signature = Digest::SHA1.hexdigest(js_sdk_signature_str)

    end
  end

  # 医生完成线下咨询服务
  def complete_offline_consult
    resource.diagnose!

    redirect_to my_doctors_reservation_path(resource) and return
  end

  # 电话咨询，用户不用再支付了, 系统自动改状态
  def complete_online_consult
    resource.diagnose! do
      resource.pay!
    end

    redirect_to my_doctors_reservation_path(resource) and return
  end

  private

  def reservation_params
    params.require(:reservation).permit!
  end

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end
end
