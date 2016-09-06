class Reservation < ActiveRecord::Base
  include AASM
  extend Enumerize
  extend ActiveModel::Naming

	has_many :ratings
  has_one :medical_record

  aasm do
    state :pending, initial: true
    state :reserved, :prepaid, :diagnosed, :paid, :archived

    event :reserve do
      transitions from: :pending, to: :reserved
    end

    event :prepay do
      transitions from: :reserved, to: :prepaid
    end

		event :diagnose do
			transitions from: :prepaid, to: :diagnosed
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

  enumerize :aasm_state, in: [:pending, :reserved, :prepaid, :diagnosed, :paid, :archived], default: :pending, predicates: true

  GENDERS = %w(儿子 女儿).freeze
  def marked_phone_number
    # http://stackoverflow.com/questions/26103394/regular-expression-to-mask-all-but-the-last-4-digits-of-a-social-security-number
    # Simply extract the last four characters and append them to a string of five '*'
		if mobile_phone.present?
	    '*' * 7 + mobile_phone[-4..-1]
		end
  end

  def rating_by_doctor
    self.ratings.where(rated_by: self.user_b).first
  end

  def rating_by_patient
    self.ratings.where(rated_by: self.user_a).first
  end

	def doctor_has_rated?
		rating_by_doctor.present?
	end

	def patient_has_rated?
    rating_by_patient.present?
	end

	def rated?
		doctor_has_rated? && patient_has_rated?
	end

end
