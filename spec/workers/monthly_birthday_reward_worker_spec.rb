require 'sidekiq/testing'

RSpec.describe MonthlyBirthdayRewardWorker, type: :worker do
  describe '#perform' do
    let!(:normal_users) { create_list(:user, 5, birthdate: 2.months.ago.to_date) }
    let!(:birthday_user) { create(:user, birthdate: Date.current) }
    let!(:reward) { create(:reward, name: 'Free Coffee') }

    it 'awards birthday users with free coffee' do
      expect do
        MonthlyBirthdayRewardWorker.new.perform
      end.to change { Claim.count }.by(1)
      expect(Claim.first.user).to eq(birthday_user)
    end
  end
end
