# frozen_string_literal: true

class SettleTransactionsWithDoctorJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # 用户付款后的第七天可以结算医生的订单 settleable
    Transaction.pending.where(['created_at <=  ?', Time.zone.now - 7.days]).find_each(&:settle!)
  end
end
