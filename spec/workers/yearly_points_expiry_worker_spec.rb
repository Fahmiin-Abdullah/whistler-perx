require 'sidekiq/testing'

RSpec.describe YearlyPointsExpiryWorker, type: :worker do
  describe '#perform' do
    let(:user) { create(:user, points_cached: 200) }

    it 'creates points archive record' do
      expect do
        YearlyPointsExpiryWorker.new.perform
      end.to change { user.reload.points_cached }.by(-200).
      and change { PointsArchive.count }.by(1)
      expect(PointsArchive.first.total).to eq(200)
    end
  end
end
