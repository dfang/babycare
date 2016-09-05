class My::Patients::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []

  def index
    @medical_records = current_user.medical_records.order('created_at DESC')
  end

  def status
  end

  def show
  end

  private

  def begin_of_association_chain
    current_user
  end

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def medical_record_params
    params.require(:medical_record).permit!
  end
end
