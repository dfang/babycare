class My::Doctors::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_reservation
  skip_before_action :find_reservation, except: [:create, :update]

  def create
    create! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      end
    }
  end

  def update
    update! {
      if @reservation.present?
        my_doctors_reservation_path(@reservation)
      end
    }
  end

  private

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
  end
end
