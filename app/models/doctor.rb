class Doctor < ActiveRecord::Base
  belongs_to :user

  JOB_TITLES = [ "主任医师", "副主任医师", "主治医师", "住院医师" ]
end
