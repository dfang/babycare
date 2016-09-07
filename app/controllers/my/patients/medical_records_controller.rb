class My::Patients::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_reservation, only: [:create, :update]

  def index
    @medical_records = current_user.medical_records.order('created_at DESC')
  end

  def create
    create! {
      my_patients_reservation_path(@reservation)
    }
  end

  def update
    update! {
      my_patients_reservation_path(@reservation)
    }
  end

  def status
  end

  def show
  end

  private

  # def begin_of_association_chain
  #   current_user
  # end

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
