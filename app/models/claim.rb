class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  # ==============================================================================
  # Accepts:
  # user        => user the reward is being issued to
  # reward      => the reward being issued
  # description => some descriptio about the claim
  #
  # Checks to see if reward is already claimed.
  # ==============================================================================
  def self.reward_claimed?(user, reward, description)
    exists?(user_id: user.id, reward_id: reward.id, description: description)
  end
end
