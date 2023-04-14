class TopupsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, :authenticate_user!, only: [:stk_result]

  def new
    @topup = current_user.topups.build
  end

  def charge
    @topup = current_user.topups.build(topup_params)
    if @topup.save
      charge_response = TopupMpesaJob.perform_now(topup_id: @topup.id, phone_number: @topup.phone_number, amount: @topup.amount)
      if charge_response.present? && charge_response.ResponseCode.to_i.zero?
        render json: {success: true, message: "MPESA stk push successful"}, status: :ok
      else
        render json: {success: false, message: "MPESA stk push failed"}, status: :unprocessable_entity
      end
    end
  end  

  def stk_result
    callback_body = params.require(:Body).permit(stkCallback: {})
    head :no_content
    result = ProcessStkResult.new(callback_body[:stkCallback]).execute
  end

  private

  def topup_params
    params.permit(:id, :amount, :phone_number)
  end
end
