# coding: utf-8
# frozen_string_literal: true

# https://medium.com/@pdrgc/refactoring-long-aasm-modules-d0e331f2054d
module ClientStateMachine
  autoload :Reservation, 'state_machine/reservation'
  extend ActiveSupport::Concern

  included do
    include ClientStateMachine::Reservation
  end
end
