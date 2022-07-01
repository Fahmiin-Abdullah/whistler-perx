class ChangeTransactionReferenceInPointsRecordsTable < ActiveRecord::Migration[6.1]
  def change
    change_column :points_records, :transaction_id, :integer, null: true
  end
end
