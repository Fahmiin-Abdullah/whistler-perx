class Transaction < ApplicationRecord
  belongs_to :user
  has_many :points_records
end
