# frozen_string_literal: true

class Admin::DoctorsController < Admin::BaseController
  custom_actions resource: :confirm, collection: :search

  def show; end

  def confirm
    resource.verify if params.key?(:id)
    redirect_to(admin_doctors_path) && return
  end
end
