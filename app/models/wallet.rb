class Wallet < ActiveRecord::Base
  belongs_to :user

  def total_balance
    self.balance_withdrawable.to_f + self.balance_unwithdrawable.to_f
  end
end
