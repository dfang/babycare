class Person < ActiveRecord::Base
  acts_as_nested_set
  has_one :medical_record

  accepts_nested_attributes_for :children
end