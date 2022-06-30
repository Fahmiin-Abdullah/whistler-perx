require 'rails_helper'

RSpec.describe RewardsService, type: :service do
  let(:user) { create(:user) }
  let!(:reward_1) { create(:reward, name: 'Free Coffee') }
  let!(:reward_2) { create(:reward, name: '5% Cash Rebate') }
  let!(:reward_3) { create(:reward, name: 'Free Movie Tickets') }

  describe '::award_free_coffee' do
    context 'when user accumulates > 100 points in a month' do
      let!(:points_record) { create(:points_record, user: user, amount: 200) }

      it 'issues free coffee reward' do
        expect do
          RewardsService.new(user).award_free_coffee
        end.to change { Claim.exists?(user_id: user.id, reward_id: reward_1.id, description: 'Get 100 points in a month') }.to(true)
      end
    end

    context 'when user accumulates > 100 points in 2 months' do
      let!(:points_record_1) { create(:points_record, user: user, amount: 90) }
      let!(:points_record_2) { create(:points_record, user: user, amount: 10, created_at: 2.months.ago) }

      it 'issues no rewards' do
        expect { RewardsService.new(user).award_free_coffee }.not_to change { Claim.count }
      end
    end
  end

  describe '::award_cash_rebate' do
    context 'when user has 10 transactions amounting to > $100' do
      let!(:transactions) { create_list(:transaction, 11, user: user, amount: 200) }

      it 'issues cash rebate reward' do
        expect do
          RewardsService.new(user).award_cash_rebate
        end.to change {
          Claim.exists?(user_id: user.id, reward_id: reward_2.id, description: 'Have 10 transactions amounting to $100 or more')
        }.to(true)
      end
    end

    context 'when user accumulates only 5 transactions amounting to > $100' do
      let!(:transactions) { create_list(:transaction, 5, user: user, amount: 200) }

      it 'issues no rewards' do
        expect { RewardsService.new(user).award_cash_rebate }.not_to change { Claim.count }
      end
    end
  end

  describe '::award_free_movie_tickets' do
    context 'when user spent > $1000 within 60 days' do
      let!(:transactions) { create_list(:transaction, 10, user: user, amount: 200) }

      it 'issues cash rebate reward' do
        expect do
          RewardsService.new(user).award_free_movie_tickets
        end.to change {
          Claim.exists?(user_id: user.id, reward_id: reward_3.id, description: 'Spend more than $1000 within the first 60 days of spending')
        }.to(true)
      end
    end

    context 'when user did not spend > $1000' do
      let!(:transactions) { create_list(:transaction, 10, user: user, amount: 100) }

      it 'issues no rewards' do
        expect { RewardsService.new(user).award_free_movie_tickets }.not_to change { Claim.count }
      end
    end

    context 'when user spent > $1000 within 1 year' do
      let!(:transactions_1) { create_list(:transaction, 5, user: user, amount: 100) }
      let!(:transactions_2) { create_list(:transaction, 5, user: user, amount: 100, created_at: 1.year.ago) }

      it 'issues no rewards' do
        expect { RewardsService.new(user).award_free_movie_tickets }.not_to change { Claim.count }
      end
    end
  end
end
