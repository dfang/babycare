# frozen_string_literal: true

class GlobalImage < Image
  mount_uploader :data, MainUploader
  validates :data, presence: true

  belongs_to :user
end
