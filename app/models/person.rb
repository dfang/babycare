class Person < ActiveRecord::Base
  acts_as_nested_set
  # has_one :medical_record, dependent: :destroy
  has_many :medical_records, dependent: :destroy

  accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true
  mattr_accessor :relationships
  belongs_to :province
  belongs_to :city
  belongs_to :district

  def full_address
    self.province
  end
end