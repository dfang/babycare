class Image < ActiveRecord::Base
  mount_uploader :data, AdminImageUploader
end
