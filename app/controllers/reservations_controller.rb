class ReservationsController < InheritedResources::Base
  before_action -> { authenticate_user!( force: true ) }

  before_action :deny_doctors
  skip_before_action :deny_doctors, only: [ :public, :show, :status ]


  before_action -> { patient_and_has_children? }
  before_action -> { ensure_registerd_membership }
  # custom_actions :resource => :wxpay_test
  # before_action :rectrict_access
  # skip_before_action :rectrict_access, only: [ :restricted ]

  def public
    @is_doctor = current_user.doctor.present?
    @reservations = Reservation.pending.order("reservation_date ASC")
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_a = current_user.id
    create! {
      status_reservation_path(resource)
    }
  end

  def new
    @symptoms = Symptom.all.group_by(&:name).map { |k, v| k }.to_json
    @symptom_details = Symptom.all.group_by(&:name).map { |k, v| {name: k, values: v.map(&:detail) } }.to_json
    super
  end

  def restricted
  end

  def status
  end

  def wxpay_test
    params = {
      body: '测试商品',
      out_trade_no: 'test003',
      total_fee: 1,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'http://wx.yhuan.cc/wcpay/notify',
      trade_type: 'JSAPI',
      openid: 'ox-t3s_BIGA0KgFWzwNrnFE-pE28'
    }
    result = WxPay::Service.invoke_unifiedorder params

    @order_params = {
      appId: Settings.wx_pay.appid,
      timeStamp: DateTime.now.utc.to_i,
      nonceStr:  SecureRandom.hex,
      signType:  "MD5",
      package:   "prepay_id=#{result[:prepay]}",
      paySign:   "#{result[:sign]}"
    }

    # WxPay::Service::generate_js_pay_req

    p '@order_params'
    p @order_params
  end

  private

  def rectrict_access
    access = AccessWhitelist.find_by(uid: current_user.wechat_authentication.try(:uid))
    if access.blank?
      redirect_to restricted_reservations_path and return
    end
  end

  def reservation_params
    params.require(:reservation).permit!
  end

  def deny_doctors
    if current_user.doctor.present? && current_user.doctor.verified?
      flash[:error] = "你是医生不能访问该页面"
      redirect_to global_denied_path and return
    end
  end

  def patient_and_has_children?
    # 如果没有小孩，那就先去添加孩子的资料
    if current_user.is_patient? && current_user.children.blank?
      redirect_to patients_family_members_path, alert: "你还没有添加小孩" and return
    end
  end

  def ensure_registerd_membership
    # 如果是非会员， 第二次预约就要邀请他加入会员了
    # 如果是会员的， 第二次预约的判断资料是不是完善的，如果不是完善的话，就要提醒他完善了
  end
end
