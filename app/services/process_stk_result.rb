class ProcessStkResult
  def initialize(stk_callback)
    @stk_callback = stk_callback.with_indifferent_access
  end

  def execute
    if @topup.present?
      @topup.charge_result = @processed_result || @stk_callback
      @topup.status = payment_status
      @topup.provider_reference = @processed_result[:MpesaReceiptNumber] if @processed_result.present?
      @topup.tap do |s|
        s.save!
        update_wallet_balance
      end
    else
      Rails.logger.warn(
        "Received stk callback without matching topup, CheckoutRequestID: #{@stk_callback[:CheckoutRequestID]}"
      )
    end
  end

  private

  def flatten_callback_metadata
    return if @stk_callback[:CallbackMetadata].blank?

    callback_metadata = @stk_callback[:CallbackMetadata][:Item].each_with_object({}) do |item, meta|
      meta[item[:Name]] = item[:Value]
    end
    @processed_result = @stk_callback.merge(callback_metadata)
  end

  def set_topup
    Topup.by_checkout_request_id(@stk_callback[:CheckoutRequestID]).take
  end

  def payment_status
    return "failed" unless @stk_callback[:ResultCode].zero?

    (@processed_result[:Amount] >= @topup.amount) ? "paid" : "partial"
  end

  def update_wallet_balance
    if @topup.paid?
      @topup.user.wallet.update(amount: @topup.account.wallet.amount + @topup.amount)
      @topup.save
    else
      Rails.logger.warn("Processed partial payment for topup#{@topup.id}")
    end
  end
end
