# frozen_string_literal: true

class ReservationsController < InheritedResources::Base
  include ReservationsHelper

  before_action -> { authenticate_user!(force: true) }

  before_action :deny_doctors
  skip_before_action :deny_doctors, only: %i[public show status]

  # 看下手机号是不是valid
  before_action -> { ensure_mobile_phone_valid? }
  # 看下病人有没有添加小孩信息
  # before_action -> { patient_and_has_children? }
  # 看下病人是不是付费会员
  before_action -> { ensure_registerd_membership }

  # custom_actions :resource => :wxpay_test
  # before_action :rectrict_access
  # skip_before_action :rectrict_access, only: [ :restricted ]

  def public
    @is_doctor = current_user.doctor.present?
    @reservations = Reservation.prepaid.order('reservation_date ASC')
  end

  def create
    if !reservation_params.key?(:family_member_id)
      child = current_user.children.build(build_children_options(family_member_params))
      child.save!
      reservation_params.merge!(family_member_id: child.id)
    end
    @reservation = current_user.reservations.build(reservation_params)
    p reservation_params
    p @reservation

    Rails.logger.info @reservation.valid?
    Rails.logger.info @reservation.errors.messages

    # @reservation.save
    # respond_with(@reservation)
    create! do
      if @reservation.valid?
        status_reservation_path(resource)
      else
        new_reservation_path
      end
    end
  end

  def new
    @symptoms = Symptom.all.group_by(&:name).map { |k, _v| k }.to_json
    @symptom_details = Symptom.all.group_by(&:name).map { |k, v| { name: k, values: v.map(&:detail) } }.to_json
    # super
  end

  def restricted; end

  def status; end

  private

  def rectrict_access
    access = AccessWhitelist.find_by(uid: current_user.wechat_authentication.try(:uid))
    redirect_to(restricted_reservations_path) && return if access.blank?
  end

  def family_member_params
    params.require(:user).permit!
  end

  def reservation_params
    params.require(:reservation).permit!
  end

  def deny_doctors
    flash[:error] = '你是医生不能访问该页面'
    redirect_to(global_denied_path) if current_user.verified_doctor?
    # if current_user.doctor.present? && current_user.doctor.verified?
    #   flash[:error] = '你是医生不能访问该页面'
    #   redirect_to(global_denied_path) && return
    # end
  end

  def patient_and_has_children?
    # 如果没有小孩，那就先去添加孩子的资料
    flash[:alert] = '你还没有添加小孩'
    redirect_to(patients_family_members_path) if current_user.patient_and_has_no_children?
  end

  def ensure_registerd_membership
    # 如果是非会员， 第二次预约就要邀请他加入会员了
    # 如果是会员的， 第二次预约的判断资料是不是完善的，如果不是完善的话，就要提醒他完善了
    true
  end

  def ensure_mobile_phone_valid?
    # redirect_to(validate_phone_path) && return if current_user.mobile_phone.blank?
    redirect_to(edit_patients_settings_path) && return if current_user.mobile_phone.blank?
  end
end
