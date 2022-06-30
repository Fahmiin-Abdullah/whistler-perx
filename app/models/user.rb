class User < ApplicationRecord
  has_many :transactions
  has_many :points_records
end
