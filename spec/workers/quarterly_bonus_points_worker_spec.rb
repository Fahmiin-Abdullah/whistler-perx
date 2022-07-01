require 'sidekiq/testing'

RSpec.describe QuarterlyBonusPointsWorker, type: :worker do
  describe '#perform' do
    let(:user) { create(:user) }
    let!(:last_quarter_transactions) { create_list(:transaction, 5, user: user, created_at: 5.months.ago) }
    let!(:this_quarter_transactions) { create(:transaction, user: user, amount: 100) }

    context 'when not sufficient spending' do
      it 'does nothing' do
        expect do
          QuarterlyBonusPointsWorker.new.perform
        end.to change { user.reload.points_cached }.by(0)
      end
    end

    context 'when user spending surpasses $2000' do
      let!(:more_this_quarter_transactions) { create_list(:transaction, 20, user: user, amount: 200) }

      it 'awards bonus points' do
        expect do
          QuarterlyBonusPointsWorker.new.perform
        end.to change { user.reload.points_cached }.by(100).
        and change { PointsRecord.count }.by(1)
      end
    end
  end
end
