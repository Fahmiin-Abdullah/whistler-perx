class User < ApplicationRecord
  has_many :transactions
  has_many :points_records
  has_many :points_archives
  has_many :claims
  has_many :rewards, through: :claims

  after_save :recalculate_tier

  # ==============================================================================
  # Recalculate points and updates new tier on user if any changes
  # If user upgrades to gold tier, award 4x Airport Lounge Access rewards
  # ==============================================================================
  def recalculate_tier
    prev_highest_points = points_archives.pluck(:total).last(2).max || 0
    tier_points = prev_highest_points + points_cached
    new_tier =
      if tier_points >= 5000
        'platinum'
      elsif tier_points >= 1000
        'gold'
      else
        'standard'
      end
    return unless tier != new_tier

    update_columns(tier: new_tier)
    return unless tier == 'gold'

    4.times { RewardsService.new(self).award_airport_lounge_access }
  end
end
