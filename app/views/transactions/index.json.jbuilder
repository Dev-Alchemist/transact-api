json.array! @transactions do |transaction|
  json.extract! transaction, :id, :amount, :created_at

  json.sender do
    json.extract! transaction.sender, :id, :email, :phone_number
  end

  json.recipient do
    json.extract! transaction.recipient, :id, :email, :phone_number
  end
end
