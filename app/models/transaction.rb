class Transaction < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, polymorphic: true

  validates :amount, presence: true, numericality: {greater_than: 0}

  scope :between_dates, lambda { |start_date, end_date|
                          if start_date.present? && end_date.present?
                            where(created_at: start_date.to_time.beginning_of_day..end_date.to_time.end_of_day)
                          end
                        }
end
