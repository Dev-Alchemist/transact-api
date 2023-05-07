class CreateTransaction
  def initialize(sender, params)
    @sender = sender
    @recipient_email = params[:recipient_email]
    @recipient_phone_number = params[:recipient_phone_number]
    @amount = params[:amount].to_d
  end

  def call
    recipient = find_recipient

    if recipient && sender.balance >= amount
      transaction = sender.sent_transactions.build(recipient: recipient, amount: amount)

      if transaction.save
        update_balances(transaction)
        send_notifications(transaction)

        transaction
      end
    else
      transaction = Transaction.new

      if !recipient
        transaction.errors.add(:recipient, "not found")
      elsif sender.balance < amount
        transaction.errors.add(:balance, "insufficient")
      end

      transaction
    end
  end

  private

  attr_reader :sender, :recipient_email, :recipient_phone_number, :amount

  def find_recipient
    User.find_by(email: recipient_email) || User.find_by(phone_number: recipient_phone_number)
  end

  def update_balances(transaction)
    sender.update(balance: sender.balance - amount)
    transaction.recipient.update(balance: transaction.recipient.balance + amount)

    transaction.update(
      sender_balance_before: sender.balance_before_last_save,
      sender_balance_after: sender.balance,
      recipient_balance_before: transaction.recipient.balance_before_last_save,
      recipient_balance_after: transaction.recipient.balance
    )
  end

  def send_notifications(transaction)
    TransactionMailer.confirmation_email(transaction).deliver_later
    TransactionNotification.with(sender: sender, amount: amount).deliver(transaction.recipient)
  end
end
