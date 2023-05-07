class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = Transaction.all

    render :index
  end

  def create
    transaction = CreateTransaction.new(current_user, transaction_params).call

    if transaction.persisted?
      render json: {message: "Transaction successful"}, status: :created
    else
      render json: {error: transaction.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:recipient_email, :recipient_phone_number, :amount)
  end
end
