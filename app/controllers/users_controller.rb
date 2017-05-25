require 'rqrcode'

class UsersController < InheritedResources::Base
  before_action ->{ authenticate_user!( force: true ) }

  # /users/:id/scan_qrcode 用户打开这个页面让医生扫描
  def scan_qrcode
    @qr = RQRCode::QRCode.new( qrcode_user_url(current_user), :size => 6, :level => :h )
  end


  # /users/:id/qrcode 医生扫描后进入这个页面
  def qrcode
    user = User.find_by(id: params[:id])
    latest_reservation = user.reservations.where(user_b: current_user.id).order('created_at DESC').first
    if current_user.is_doctor?
      redirect_to profile_my_doctors_patient_path(user)
    end
  end

  def children
  end
end
