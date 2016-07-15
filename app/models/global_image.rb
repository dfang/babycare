class GlobalImage < ActiveRecord::Base
  mount_uploader :data, MainUploader
  validates :data, presence: true

  belongs_to :user
end
