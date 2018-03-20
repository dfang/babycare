# frozen_string_literal: true

class Doctors::ReservationsController < Doctors::BaseController
  # TODO should remove this, add csrf token in ajax header
  skip_before_action :verify_authenticity_token, only: [:status, :update]

  custom_actions collection: %i[available reservations status not_found], member: %i[claim complete_offline_consult complete_online_consult]

  def reservations; end


  # 我要接单
  def available
    @reservations = current_user.doctor.reservations.prepaid
  end

  def index
    Rails.logger.info params
    @reservations = current_user.doctor.reservations.select { |r| !r.prepaid? }
    # @reservations = if params.key?(:aasm_state)
    #                   # 医生我要接单页面
    #                   # /doctors/reservations?aasm_state=prepaid
    #                   current_user.doctor.reservations.prepaid
    #                 else
    #                   # 医生的所有预约页面
    #                   # /doctors/reservations
    #                   current_user.doctor.reservations.select { |r| !r.prepaid? }
    #                 end
    # p params
    # if params.key?(:id)
    #   # /doctors/patients/22/reservations
    #   # {"controller"=>"doctors/reservations", "action"=>"index", "id"=>"22"}
    #   # 医生查看某病人和自己的所有的预约页面
    #   @user = User.find_by(id: params[:id])
    #   @reservations = @user.reservations.order('updated_at DESC')
    # else
    #   # /doctors/reservations
    #   # {"controller"=>"doctors/reservations", "action"=>"index"}
    #   # 医生的所有预约页面
    #   @reservations = current_user.reservations.order('updated_at DESC')
    # end
  end

  def show
    # /doctors/reservations/106
    # {"controller"=>"doctors/reservations", "action"=>"show", "id"=>"106"}
    super
  end

  def not_found; end

  def detail; end

  def status; end

  def update
    # binding.pry

    if reservation_params.key?(:event) && reservation_params.delete(:event) == 'claim'

      has_examinations = reservation_params.delete(:examinations)
      resource.reservation_examinations.delete_all if has_examinations == 'off'

      resource.update(reservation_params.except(:event))

      # TODO: 需要判断下是否有检查项目 resource.upload_examination!
      if resource.reservation_examinations.present?
        resource.reserve_to_examine!
      else
        resource.reserve_to_consult!
      end
      redirect_to doctors_reservation_path
    else
      super
    end
  end

  # 医生认领用户的预约
  # def claim
  #   if request.put?
  #     resource.update(reservation_params)
  #     resource.user_b = current_user.id
  #
  #     resource.reserve!
  #
  #     redirect_to(doctors_reservation_path(resource)) && return
  #   else
  #     @appId = Settings.wx_pay.app_id
  #     @nonceStr = SecureRandom.hex
  #     @timestamp = DateTime.now.to_i
  #     js_sdk_signature_str = { jsapi_ticket: WxApp::WxCommon.get_jsapi_ticket, noncestr: @nonceStr, timestamp: @timestamp, url: request.url }.sort.map do |k, v|
  #       "#{k}=#{v}" if v != '' && !v.nil?
  #     end.compact.join('&')
  #     @signature = Digest::SHA1.hexdigest(js_sdk_signature_str)
  #   end
  # end

  # 医生完成线下咨询服务
  def complete_offline_consult
    resource.diagnose!

    redirect_to(doctors_reservation_path(resource)) && return
  end

  # 电话咨询，用户不用再支付了, 系统自动改状态
  def complete_online_consult
    resource.diagnose! do
      resource.pay!
    end

    redirect_to(doctors_reservation_path(resource)) && return
  end

  def chief_complains; end

  private

  def reservation_params
    params.require(:reservation).permit!
  end

  def check_is_verified_doctor
    unless current_user.verified_doctor?
      redirect_to(doctors_status_path) && return
    end
  end
end
