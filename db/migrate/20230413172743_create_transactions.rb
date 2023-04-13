class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :sender, null: false, foreign_key: {to_table: :users}
      t.references :recipient, polymorphic: true, null: false
      t.decimal :amount

      t.timestamps
    end
  end
end
