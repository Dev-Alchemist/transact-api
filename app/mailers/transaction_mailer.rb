class TransactionMailer < ApplicationMailer
  def confirmation_email(transaction)
    @transaction = transaction
    mail(to: transaction.sender.email, subject: "Transaction confirmation")
  end
end
