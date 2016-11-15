class Transaction < ActiveRecord::Base
  extend Enumerize

  enumerize :source, in: [:offline_consult, :online_consult], default: :offline_consult, predicates: true, scope: true
  enumerize :operation, in: [:income, :withdraw], default: :income, predicates: true, scope: true


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

end
