require 'test_helper'

class TopupTest < ActiveSupport::TestCase
  def setup
    @topup = topups(:john_topup)
  end

  test "should be valid" do
    assert @topup.valid?
  end

  test "user should be present" do
    @topup.user = nil
    assert_not @topup.valid?
  end

  test "amount should be present" do
    @topup.amount = nil
    assert_not @topup.valid?
  end

  test "amount should be greater than 0" do
    @topup.amount = 0
    assert_not @topup.valid?
    @topup.amount = -10
    assert_not @topup.valid?
  end

  test "status should be pending by default" do
    topup = Topup.new
    assert_equal "pending", topup.status
  end

  test "should be able to query by checkout_request_id" do
    assert_equal [@topup], Topup.by_checkout_request_id("1234")
    assert_equal [], Topup.by_checkout_request_id("5678")
  end

  test "should set reference when initialized" do
    topup = Topup.new(user: users(:john), amount: 10)
    assert_not_nil topup.reference
  end

  test "should not set reference if already present" do
    @topup.reference = "TRANSACT/2023/5/100"
    @topup.save
    assert_equal "TRANSACT/2023/5/100", @topup.reference
  end

  test "should be able to check if paid" do
    assert_not @topup.paid?
    assert topups(:jane_topup).paid?
  end

  test "should be able to store checkout_request_id" do
    @topup.checkout_request_id = "9876"
    @topup.save
    assert_equal "9876", @topup.reload.checkout_request_id
  end
end