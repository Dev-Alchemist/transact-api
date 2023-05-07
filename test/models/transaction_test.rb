require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def setup
    @sender = users(:john)
    @recipient = users(:jane)
    @transaction = Transaction.new(sender: @sender, recipient: @recipient, amount: 50.0)
  end

  test "should be valid" do
    assert @transaction.valid?
  end

  test "amount should be greater than 0" do
    @transaction.amount = 0
    assert_not @transaction.valid?
  end
end
