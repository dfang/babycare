class Transaction < ActiveRecord::Base
  include AASM
  extend Enumerize

  enumerize :source, in: [:offline_consult, :online_consult], default: :offline_consult, predicates: true, scope: true
  enumerize :operation, in: [:income, :withdraw], default: :income, predicates: true, scope: true
  enumerize :aasm_state, in: [ :pending, :settled ], default: :pending, predicates: true, scope: true

  aasm do
    state :pending, initial: true
    state :settled
    event :settle, after_transaction: :after_settled! do
      transitions from: :pending, to: :settle
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
