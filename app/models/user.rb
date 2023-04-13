class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :sent_transactions, class_name: "Transaction", foreign_key: "sender_id", dependent: :destroy
  has_many :received_transactions, class_name: "Transaction", foreign_key: "recipient_id", dependent: :destroy
  has_many :topups, dependent: :destroy
end
