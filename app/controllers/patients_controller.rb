# frozen_string_literal: true

class PatientsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }

  def index; end
end
