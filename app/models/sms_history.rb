class SmsHistory < ActiveRecord::Base
  belongs_to :reservation
end
