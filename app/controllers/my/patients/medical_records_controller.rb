class My::Patients::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []
  before_action :find_reservation, only: [:create, :update]
  skip_before_action :find_reservation, except: [:create, :update]

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

  def new
    @medical_record ||= MedicalRecord.new
    # @medical_record.blood_type = current_user.settings.first.try(:blood_type)
    # @medical_record.blood_pressure = current_user.settings.first.try(:blood_type)
    @medical_record.birthdate = current_user.settings.first.try(:birthdate)
    @medical_record.gender = current_user.settings.first.try(:gender)
    @medical_record.history_of_present_illness = current_user.settings.first.try(:history_of_present_illness)
    @medical_record.past_medical_history = current_user.settings.first.try(:past_medical_history)
    @medical_record.allergic_history = current_user.settings.first.try(:allergic_history)
    @medical_record.personal_history = current_user.settings.first.try(:personal_history)
    @medical_record.family_history = current_user.settings.first.try(:family_history)
    @medical_record.vaccination_history = current_user.settings.first.try(:vaccination_history)
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
