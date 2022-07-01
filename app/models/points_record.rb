class PointsRecord < ApplicationRecord
  belongs_to :user
  belongs_to :transaction_record, class_name: 'Transaction', foreign_key: :transaction_id, optional: true
end
