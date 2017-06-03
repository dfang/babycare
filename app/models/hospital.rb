# frozen_string_literal: true

class Hospital < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :city
end
