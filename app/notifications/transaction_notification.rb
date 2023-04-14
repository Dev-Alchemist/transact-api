# To deliver this notification:
#
# TransactionNotification.with(post: @post).deliver_later(current_user)
# TransactionNotification.with(post: @post).deliver(current_user)

class TransactionNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "TransactionMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def email_subject
    "#{params[:sender].email} sent you a new transaction"
  end
  #
  # def url
  #   post_path(params[:post])
  # end
end
