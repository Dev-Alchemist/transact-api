class Transaction < ApplicationRecord
  belongs_to :sender
  belongs_to :recipient, polymorphic: true

  validates :amount, presence: true, numericality: {greater_than: 0}
end
