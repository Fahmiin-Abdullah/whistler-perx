class TransactionWorker
  include Sidekiq::Worker

  # ==============================================================================
  # Accepts:
  # user_id     => id of user performing the transaction
  # currency    => 'SGD' is normal, other foreign currencies is 2x
  # amount      => amount of money spent in this transaction
  # description => some description regarding the transaction performed
  #
  # Creates the transaction, point record, update user points and issue rewards
  # ==============================================================================
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
