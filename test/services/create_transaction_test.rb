require "test_helper"

class CreateTransactionTest < ActiveSupport::TestCase
  test "creates transaction when sender has enough balance" do
    sender = users(:john)
    recipient = users(:jane)
    amount = 50

    assert_difference "Transaction.count", 1 do
      CreateTransaction.call(sender, recipient, amount)
    end

    assert_equal sender.balance - amount, sender.reload.balance
    assert_equal recipient.balance + amount, recipient.reload.balance
  end

  test "raises error when sender has insufficient balance" do
    sender = users(:john)
    recipient = users(:jane)
    amount = 200

    assert_raises CreateTransaction::InsufficientBalanceError do
      CreateTransaction.call(sender, recipient, amount)
    end

    assert_equal sender.balance, sender.reload.balance
    assert_equal recipient.balance, recipient.reload.balance
  end

  test "raises error when recipient is nil" do
    sender = users(:john)
    recipient = nil
    amount = 50

    assert_raises CreateTransaction::RecipientNotFoundError do
      CreateTransaction.call(sender, recipient, amount)
    end

    assert_equal sender.balance, sender.reload.balance
  end
end
