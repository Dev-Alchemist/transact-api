class Transaction < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, polymorphic: true

  validates :amount, presence: true, numericality: {greater_than: 0}

  after_create :update_balances

  private

  def update_balances
    sender.update(balance: sender.balance - amount)
    recipient.update(balance: recipient.balance + amount)

    update(
      sender_balance_before: sender.balance_before_last_save,
      sender_balance_after: sender.balance,
      recipient_balance_before: recipient.balance_before_last_save,
      recipient_balance_after: recipient.balance
    )
  end
end
