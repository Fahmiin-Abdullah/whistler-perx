class YearlyPointsExpiryWorker
  include Sidekiq::Worker

  # ==============================================================================
  # Accepts:
  # N/A
  #
  # Archives the user points for the year. Reset user points to 0
  # ==============================================================================
  def perform
    User.in_batches.each_record do |user|
      PointsArchive.create!(user: user, year: Date.current.year, total: user.points_cached)
      user.points_cached = 0
      user.save!
    end
  end
end
