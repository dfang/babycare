class Doctor < ActiveRecord::Base
  belongs_to :user
  has_many :reservations, :foreign_key => 'user_b'

  JOB_TITLES = [ "主任医师", "副主任医师", "主治医师", "住院医师" ]


  def confirm!
    self.verified = true
    self.save!
  end
end
