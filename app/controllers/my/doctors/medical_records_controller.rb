class My::Doctors::MedicalRecordsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []

  private

  def current_wechat_authentication
    current_user.authentications.where(provider: 'wechat').first
  end

  def medical_record_params
    params.require(:medical_record).permit!
  end
end
