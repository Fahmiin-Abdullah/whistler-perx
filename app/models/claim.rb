class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  def self.reward_claimed?(user, reward, description)
    exists?(user_id: user.id, reward_id: reward.id, description: description)
  end
end
