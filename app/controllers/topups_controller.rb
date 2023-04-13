class TopupsController < ApplicationController
  before_action :authenticate_user!

  def charge
    topup = Topup.create(amount: topup_params[:amount], phone: topup_params[:phone])
    if topup.save
      TopupMpesaJob.perform_now(topup_id: topup.id, phone: topup.phone, amount: topup.amount)
    end
  end

  private

  def topup_params
    params.fetch(:topup, {}).permit(:id, :amount, :phone)
  end
end
