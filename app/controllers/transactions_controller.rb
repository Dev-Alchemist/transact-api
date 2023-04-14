class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.sent_transactions.or(current_user.received_transactions).order(created_at: :desc)
    @transactions = @transactions.where(created_at: date_range) if date_range.present?

    render :index
  end

  def create
    recipient = User.find_by(email: params[:recipient_email]) || User.find_by(phone_number: params[:recipient_phone_number])
    if recipient
      if current_user.balance >= params[:amount].to_d
        transaction = current_user.sent_transactions.build(recipient: recipient, amount: params[:amount])

        if transaction.save
          TransactionMailer.confirmation_email(transaction).deliver_later
          TransactionNotification.with(sender: current_user, amount: params[:amount]).deliver(recipient)

          render json: {message: "Transaction successful"}, status: :created
        else
          render json: {error: transaction.errors.full_messages.join(", ")}, status: :unprocessable_entity
        end
      else
        render json: {error: "Insufficient balance"}, status: :unprocessable_entity
      end
    else
      render json: {error: "Recipient not found"}, status: :not_found
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:recipient_email, :recipient_phone_number, :amount)
  end

  def date_range
    from_date = begin
      Date.parse(params[:from_date])
    rescue
      nil
    end
    to_date = begin
      Date.parse(params[:to_date])
    rescue
      nil
    end

    return nil if from_date.nil? || to_date.nil?

    from_date.beginning_of_day..to_date.end_of_day
  end
end
