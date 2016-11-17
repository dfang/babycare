class My::Doctors::TransactionsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }, except: []

  def create
    if current_user.wallet.balance_withdrawable >= transaction_params[:amount].to_f
      transaction = current_user.withdraw_cash(transaction_params[:amount].to_f)
      redirect_to my_doctors_transaction_path(transaction)
    end

  end

  def success
  end

  def show
  end

  def index
    @transactions = current_user.transactions.order("CREATED_AT DESC")
  end

  private

  def transaction_params
    params.require(:transaction).permit!
  end
end
