class TopupMpesaJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(topup_id:, phone_number: nil, amount: nil)
    @topup = Topup.find(topup_id)
    charge_response = charge(phone_number: phone_number, amount: amount)
    if charge_response.is_a?(Mpesa::Response) && charge_response.ResponseCode.to_i.zero?
      @topup.update(
        status: "charged",
        checkout_request_id: charge_response.CheckoutRequestID,
        charge_data: charge_response.to_hash
      )
    end
  end

  private

  def charge(phone_number: nil, amount: nil)
    client.stk(
      amount: @topup.amount.to_i || amount.to_i,
      phone: formatted_phone(phone_number || @topup.phone_number),
      callback_url: callback_url,
      reference: @topup.reference,
      trans_desc: "Topup charge for "
    )
  end

  def formatted_phone(phone_number)
    return phone_number if phone_number.to_s.start_with?("254")

    phone_number.to_s.gsub(/^0?(\d+)/, '254\1')
  end

  def callback_url
    ENV["STK_CALLBACK_URL"]
  end

  def client
    Mpesa::Client.new(
      key: Rails.application.credentials.mpesa[:key],
      secret: Rails.application.credentials.mpesa[:secret],
      pass_key: Rails.application.credentials.mpesa[:pass_key],
      shortcode: Rails.application.credentials.mpesa[:shortcode],
      env: Rails.env.production? ? "production" : "sandbox"
    )
  end
end
