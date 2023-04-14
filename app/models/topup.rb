class Topup < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: {greater_than: 0}

  attribute :status, :string, default: "pending"

  store_accessor :data, :charge_data, :charge_result
  store_attribute :data, :checkout_request_id, :string

  scope :by_checkout_request_id, ->(request_id) { where("data->>'checkout_request_id' = ?", request_id) }

  after_initialize :add_reference, if: -> { reference.blank? }

  def paid?
    status == "paid"
  end

  private

  def add_reference
    last_id = 0
    last_id = Topup.last.reference.split("/").last.to_i if Topup.last
    self.reference ||= "TRANSACT/#{Time.current.year}/#{Time.current.month}/#{last_id.next}"
  end
end
