class Setting < ActiveRecord::Base
  belongs_to :user

  BLOOD_TYPES = %w(A B O AB).freeze

end
