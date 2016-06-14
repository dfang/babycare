class Person < ActiveRecord::Base
  acts_as_nested_set
  # has_one :medical_record, dependent: :destroy
  has_many :medical_records, dependent: :destroy

  accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true
  mattr_accessor :relationships

  def full_address
    self.province
  end
end