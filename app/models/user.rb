class User < ApplicationRecord
  devise :database_authenticatable,
    :jwt_authenticatable,
    :registerable,
    jwt_revocation_strategy: JwtDenylist

  has_many :sent_transactions, class_name: "Transaction", foreign_key: "sender_id", dependent: :destroy
  has_many :received_transactions, class_name: "Transaction", foreign_key: "recipient_id", dependent: :destroy
  has_many :topups, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :delete_all

  validates :email, :phone_number, presence: true
end
