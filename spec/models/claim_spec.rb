require 'rails_helper'

RSpec.describe Claim, type: :model do
  describe '#associations' do
    it { should belong_to(:user) }
    it { should belong_to(:reward) }
  end

  describe '#reward_claimed?' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward) }

    context 'when reward already claimed' do
      let!(:claim) { create(:claim, user: user, reward: reward, description: 'Achievement 1') }

      it 'returns true' do
        expect(Claim.reward_claimed?(user, reward, 'Achievement 1')).to be_truthy
      end
    end

    context 'when claim description is different' do
      it 'returns false' do
        expect(Claim.reward_claimed?(user, reward, 'Achievement 2')).to be_falsy
      end
    end
  end
end
