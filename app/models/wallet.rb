# frozen_string_literal: true

class Wallet < ActiveRecord::Base
  belongs_to :user

  def total_balance
    balance_withdrawable.to_f + balance_unwithdrawable.to_f
  end

  def total_balance_cny
    total_balance / 100.0
  end

  def balance_withdrawable_cny
    balance_withdrawable / 100.0
  end

  def balance_unwithdrawable_cny
    balance_unwithdrawable / 100.0
  end
end
