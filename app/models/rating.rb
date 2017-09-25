# frozen_string_literal: true

class Rating < OdooRecord
  self.table_name = 'fa_rating'

  belongs_to :user
  belongs_to :reservation

  acts_as_taggable
end
