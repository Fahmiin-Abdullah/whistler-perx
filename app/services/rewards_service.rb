class RewardsService
  # ==============================================================================
  # All methods related to checking elligibility and issuing rewards.
  # Each method have guard clauses that checks for uer eligbility to attain reward.
  #
  # Made use of the claim.description field to check for uniqueness of claims.
  # So these rewards can only be claimed only once.
  # ==============================================================================

  POINTS_REWARDS = %i[free_coffee cash_rebate free_movie_tickets]

  def initialize(user)
    @user = user
  end

  def issue_rewards
    POINTS_REWARDS.each do |reward|
      send("award_#{reward.to_s}")
    end
  end

  def award_free_coffee
    award_description = 'Get 100 points in a month'
    free_coffee_reward = Reward.find_by_name('Free Coffee')
    return if Claim.reward_claimed?(@user, free_coffee_reward, award_description)
    return unless PointsRecord.where('user_id = ? AND created_at >= ?', @user.id, DateTime.current.beginning_of_month).sum(:amount) >= 100

    award(free_coffee_reward, award_description)
  end

  def award_cash_rebate
    award_description = 'Have 10 transactions amounting to $100 or more'
    cash_rebate_reward = Reward.find_by_name('5% Cash Rebate')
    return if Claim.reward_claimed?(@user, cash_rebate_reward, award_description)
    return unless Transaction.where('user_id = ? AND amount > ?', @user.id, 100).count >= 10

    award(cash_rebate_reward, award_description)
  end

  def award_free_movie_tickets
    award_description = 'Spend more than $1000 within the first 60 days of spending'
    free_movie_tickets_reward = Reward.find_by_name('Free Movie Tickets')
    return if Claim.reward_claimed?(@user, free_movie_tickets_reward, award_description)

    first_transaction = Transaction.where(user_id: @user.id).order(:created_at).first
    return unless first_transaction.present? && first_transaction.created_at > 60.days.ago
    return unless Transaction.where('user_id = ? AND created_at >= ?', @user.id, first_transaction.created_at).sum(:amount) > 1000

    award(free_movie_tickets_reward, award_description)
  end

  def award_airport_lounge_access
    award_description = 'Upgraded to Gold tier'
    airport_lounge_access_reward = Reward.find_by_name('Airport Lounge Access')

    award(airport_lounge_access_reward, award_description)
  end

  def award(reward, description)
    Claim.create!(user: @user, reward: reward, description: description)
  end
end
