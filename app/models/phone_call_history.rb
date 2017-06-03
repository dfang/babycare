# frozen_string_literal: true

class PhoneCallHistory < ActiveRecord::Base
  belongs_to :reservation
end
