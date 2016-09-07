class My::Doctors::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_reservation
  skip_before_action :find_reservation, except: [:create, :update]

  def create
    create! {
      my_doctors_reservation_path(@reservation)
    }
  end

  def update
    update! {
      my_doctors_reservation_path(@reservation)
    }
  end

  private

  def find_reservation
    reservation_id ||= params[:reservation_id] || medical_record_params[:reservation_id]
    @reservation ||= Reservation.find(reservation_id)
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def medical_record_params
    params.require(:medical_record).permit!
  end
end
