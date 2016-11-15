class My::Doctors::ReservationsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }
  before_action :check_is_verified_doctor
  # skip_before_action :check_is_verified_doctor, only: [ :status ]
  custom_actions :collection => [ :reservations, :status ], :member => [ :claim ]

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

  def status
  end

  # 医生认领用户的预约
  def claim
    if request.put?
      resource.update(reservation_params)
      resource.user_b = current_user.id

      resource.reserve! do
        # reserve and send sms to notify patients to prepay
        params = [ resource.doctor_user_name, resource.reserved_time, resource.reserved_location ]
        SmsNotifyUserWhenReservedJob.perform_now(resource.patient_user_phone, params)
      end

      # 发送短信， 记录短信
      # IM::Ronglian.send_templated_sms
      redirect_to my_doctors_reservation_path(resource) and return
    end
  end

  # 医生完成线下咨询服务
  def complete
    resource.diagnose! do
      # doctor diagnosed and send sms to notify user to pay
      SmsNotifyUserWhenDiagnosedJob.perform_now(resource.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
    end
    redirect_to my_doctors_reservation_path(resource) and return
  end

  # 电话咨询，用户不用再支付了, 系统自动改状态
  def complete_online_consult
    resource.diagnose! do
      # doctor diagnosed and send sms to notify user to pay
      SmsNotifyUserWhenDiagnosedJob.perform_now(resource.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
    end

    resource.pay! do
      # user paid and send sms to doctors
      params = [resource.patient_user_name]
      SmsNotifyDoctorWhenPaidJob.perform_now(reservation.doctor_user_phone, params)
    end

    redirect_to my_doctors_reservation_path(resource) and return
  end

  private

  # def begin_of_association_chain
  #   p params
  #   @user ||= User.find_by(id: params[:id]) || current_user
  # end

  def reservation_params
    params.require(:reservation).permit!
  end

  def check_is_verified_doctor
    unless current_user.is_verified_doctor?
      redirect_to my_doctors_status_path and return
    end
  end
end
