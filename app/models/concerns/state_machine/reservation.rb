# frozen_string_literal: true

module StateMachine
  module Reservation
    extend ActiveSupport::Concern

    included do
      include AASM
      include Wisper::Publisher

      aasm do

      end


    end
  end
end
