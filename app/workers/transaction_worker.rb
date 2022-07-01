class TransactionWorker
  include Sidekiq::Worker

  def perform(user_id, currency, amount, description)
    points = PointsService.new(currency, amount).calculate_points
    user = User.find(user_id)
    user.with_lock do
      transaction = Transaction.create!(user: user, currency: currency, amount: amount, description: description)
      PointsRecord.create!(user: user, transaction_id: transaction.id, amount: points, description: description)
      user.points_cached += points
      user.save!
      RewardsService.new(user).issue_rewards
    end
  end
end
