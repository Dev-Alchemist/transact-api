class AddBalancesToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :sender_balance_before, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :transactions, :sender_balance_after, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :transactions, :recipient_balance_before, :decimal, precision: 8, scale: 2, default: 0.0, null: false
    add_column :transactions, :recipient_balance_after, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
