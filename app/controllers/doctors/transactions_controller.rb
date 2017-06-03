# frozen_string_literal: true

class Doctors::TransactionsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []

  # 提现 wallet/withdraw
  def create
    if current_user.wallet.balance_withdrawable >= transaction_params[:amount].to_f * 100
      transaction = current_user.withdraw_cash(transaction_params[:amount].to_f * 100, request.ip)
      redirect_to doctors_transaction_path(transaction)
    end
  end

  def success; end

  def show; end

  def index
    @transactions = current_user.transactions.order('CREATED_AT DESC')
  end

  private

  def transaction_params
    params.require(:transaction).permit!
  end
end
