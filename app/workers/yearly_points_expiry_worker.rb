class YearlyPointsExpiryWorker
  include Sidekiq::Worker

  def perform
    User.in_batches.each_record do |user|
      PointsArchive.create!(user: user, year: Date.current.year, total: user.points_cached)
      user.points_cached = 0
      user.save!
    end
  end
end
