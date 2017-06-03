# frozen_string_literal: true

class SmsHistory < ActiveRecord::Base
  belongs_to :reservation
end
