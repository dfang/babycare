class Transaction < ActiveRecord::Base
  include AASM
  extend Enumerize

  enumerize :source, in: [:offline_consult, :online_consult], default: :offline_consult, predicates: true, scope: true
  enumerize :operation, in: [:income, :withdraw], default: :income, predicates: true, scope: true
  enumerize :aasm_state, in: [ :pending, :settled ], default: :pending, predicates: false, scope: true

  aasm do
    state :pending, initial: true
    state :settled
    event :settle, after_transaction: :after_settled! do
      transitions from: :pending, to: :settled
    end
  end

  scope :settleable, -> { where('CREATED_AT' <= Time.now - 7.days ) }

  validates :amount, presence: true
  validates :reservation_id, presence: true, if: :income?
  validates :withdraw_target, presence: true, if: :withdraw?
  belongs_to :user

  def income?
    operation.income?
  end

  def withdraw?
    operation.withdraw?
  end

  def reservation
    if reservation_id.present?
      reservation ||= Reservation.find_by(id: reservation_id)
    end
  end

  def amount_cny
    amount / 100.0
  end

  private

  # # 结算transaction的时候
  # decrease_balance_unwithdrawable
  # increase_balance_withdrawable
  def after_settled!
    ActiveRecord::Base.transaction do
      user.decrease_balance_unwithdrawable(self.amount)
      user.increase_balance_withdrawable(self.amount)
    end
  end
end
