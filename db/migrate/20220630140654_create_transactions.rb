class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.text :description

      t.timestamps
    end
  end
end
