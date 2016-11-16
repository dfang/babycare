class SettleTransactionsWithDoctorJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # 用户付款后的第七天可以结算医生的订单 settleable
    Transaction.pending.where(["created_at <=  ?",  Time.now - 7.days ]).find_each do |tran|
      tran.settle!
    end
  end
end
