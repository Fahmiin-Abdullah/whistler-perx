class CreatePointsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :points_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :transaction, null: false, foreign_key: true
      t.integer :amount, default: 0
      t.text :description
      t.string :action, default: 'credit'

      t.timestamps
    end
  end
end
