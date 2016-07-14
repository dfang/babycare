class Admin::DoctorsController < Admin::BaseController
  custom_actions :resource => :confirm, :collection => :search

  def show
  end

  def confirm
    if params.key?(:id)
      resource.confirm!
    end
    redirect_to admin_doctors_path and return
  end
end
