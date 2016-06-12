class Person < ActiveRecord::Base
  acts_as_nested_set
  has_one :medical_record, dependent: :destroy

  accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true

  # RELATIONSHIPS = [:parents, :children]
  mattr_accessor :relationships
end