class QuarterlyBonusPointsWorker
  include Sidekiq::Worker

  def perform
    Transaction.includes(:user)
               .where('transactions.created_at > ?', 3.months.ago.beginning_of_day)
               .group(:user)
               .sum(:amount)
               .each do |user, total_spent|
      next unless total_spent > 2000

      PointsRecord.create!(user: user, amount: 100, description: 'Quarterly bonus points reward')
      user.points_cached += 100
      user.save!
    end
  end
end
