class MonthlyBirthdayRewardWorker
  include Sidekiq::Worker

  # ==============================================================================
  # Accepts:
  # N/A
  #
  # Query all users whose birthdate falls in this month.
  # Award them with free coffee.
  # ==============================================================================
  def perform
    User.where(birthdate: Date.current.all_month).in_batches.each_record do |user|
      free_coffee_reward = Reward.find_by_name('Free Coffee')
      Claim.create!(user: user, reward: free_coffee_reward, description: 'Birthday coffee reward')
    end
  end
end
