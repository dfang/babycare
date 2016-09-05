class Reservation < ActiveRecord::Base
  include AASM
  extend Enumerize
  extend ActiveModel::Naming

  aasm do
    state :pending, initial: true
    state :reserved, :prepaid, :paid, :archived

    event :reserve do
      transitions from: :pending, to: :reserved
    end

    event :prepay do
      transitions from: :reserved, to: :prepaid
    end

		event :diagnose do
			transitions from: :prepaid, to: :diagnose
		end

    event :pay do
      transitions from: :diagnosed, to: :paid
    end

    event :unreserve do
      transitions from: :reserved, to: :pending
    end

    event :archive do
      transitions from: [:pending, :reserved], to: :archived
    end
  end

  enumerize :aasm_state, in: [:pending, :reserved, :prepaid, :paid, :archived], default: :pending, predicates: true

  GENDERS = %w(儿子 女儿).freeze
  def marked_phone_number
    # http://stackoverflow.com/questions/26103394/regular-expression-to-mask-all-but-the-last-4-digits-of-a-social-security-number
    # Simply extract the last four characters and append them to a string of five '*'
		if mobile_phone.present?
	    '*' * 7 + mobile_phone[-4..-1]
		end
  end
end
