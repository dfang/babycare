# frozen_string_literal: true

class Transaction < ActiveRecord::Base
  include AASM
  extend Enumerize

  enumerize :source, in: %i[offline_consult online_consult], default: :offline_consult, predicates: true, scope: true
  enumerize :operation, in: %i[income withdraw], default: :income, predicates: true, scope: true
  enumerize :aasm_state, in: %i[pending settled], default: :pending, predicates: false, scope: true

  aasm do
    state :pending, initial: true
    state :settled
    event :settle, after_commit: :after_settled! do
      transitions from: :pending, to: :settled
    end
  end

  scope :settleable, -> { where(Time.now - 7.days >= 'CREATED_AT') }

  validates :amount, presence: true
  validates :reservation_id, presence: true, if: :income?
  validates :withdraw_target, presence: true, if: :withdraw?
  belongs_to :user

  # def income?
  #   operation.income?
  # end
  #
  # def withdraw?
  #   operation.withdraw?
  # end

  def reservation
    Reservation.find_by(id: reservation_id) if reservation_id.present?
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
      user.decrease_balance_unwithdrawable(amount)
      user.increase_balance_withdrawable(amount)
    end
  end
end
