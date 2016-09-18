class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :reservation

  acts_as_taggable
end
