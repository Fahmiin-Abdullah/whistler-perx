class RewardsService
  def initialize(user)
    @user = user
  end

  def issue_rewards
    award_free_coffee
    award_cash_rebate
    award_free_movie_tickets
  end

  def award_free_coffee
    award_description = 'Get 100 points in a month'
    free_coffee_reward = Reward.find_by_name('Free Coffee')
    return if Claim.reward_claimed?(@user, free_coffee_reward, award_description)
    return unless PointsRecord.where('user_id = ? AND created_at >= ?', @user.id, DateTime.current.beginning_of_month).sum(:amount) >= 100

    Claim.create!(user: @user, reward: free_coffee_reward, description: award_description)
  end

  def award_cash_rebate
    award_description = 'Have 10 transactions amounting to $100 or more'
    cash_rebate_reward = Reward.find_by_name('5% Cash Rebate')
    return if Claim.reward_claimed?(@user, cash_rebate_reward, award_description)
    return unless Transaction.where('user_id = ? AND amount > ?', @user.id, 100).count >= 10

    Claim.create!(user: @user, reward: cash_rebate_reward, description: award_description)
  end

  def award_free_movie_tickets
    award_description = 'Spend more than $1000 within the first 60 days of spending'
    free_movie_tickets_reward = Reward.find_by_name('Free Movie Tickets')
    return if Claim.reward_claimed?(@user, free_movie_tickets_reward, award_description)

    first_transaction = Transaction.where(user_id: @user.id).order(:created_at).first
    return unless first_transaction.present? && first_transaction.created_at > 60.days.ago
    return unless Transaction.where('user_id = ? AND created_at >= ?', @user.id, first_transaction.created_at).sum(:amount) > 1000

    Claim.create!(user: @user, reward: free_movie_tickets_reward, description: award_description)
  end

  def award_airport_lounge_access
    award_description = 'Upgraded to Gold tier'
    airport_lounge_access_reward = Reward.find_by_name('Airport Lounge Access')
    Claim.create!(user: @user, reward: airport_lounge_access_reward, description: award_description)
  end
end
