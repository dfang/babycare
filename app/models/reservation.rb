class Reservation < ActiveRecord::Base
  include AASM

  aasm do

    state :pending, :initial => true
    state :reserved, :archived

    event :reserve do
      transitions :from => :pending, :to => :reserved
    end

    event :unreserve do
      transitions :from => :reserved, :to => :pending
    end

    event :archive do
      transitions :from => [:pending, :reserved], :to => :archived
    end
  end



  GENDERS = ["儿子", "女儿"]
  def marked_phone_number
    # http://stackoverflow.com/questions/26103394/regular-expression-to-mask-all-but-the-last-4-digits-of-a-social-security-number
    # Simply extract the last four characters and append them to a string of five '*'
    '*'*7 + self.mobile_phone[-4..-1]
  end

end
