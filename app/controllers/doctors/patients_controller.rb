# frozen_string_literal: true

class Doctors::PatientsController < Doctors::BaseController
  defaults resource_class: User, collection_name: 'users', instance_name: 'user'
  custom_actions resource: [:profile]

  def profile; end
end
