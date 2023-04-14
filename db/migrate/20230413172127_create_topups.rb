class CreateTopups < ActiveRecord::Migration[7.0]
  def change
    create_table :topups do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.string :reference
      t.string :phone_number
      t.string :status
      t.jsonb :data

      t.timestamps
    end
  end
end
