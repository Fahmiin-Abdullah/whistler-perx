require 'sidekiq/testing'

RSpec.describe TransactionWorker, type: :worker do
  let(:user) { create(:user) }
  let!(:reward_1) { create(:reward, name: 'Free Coffee') }
  let!(:reward_2) { create(:reward, name: '5% Cash Rebate') }
  let!(:reward_3) { create(:reward, name: 'Free Movie Tickets') }
  let!(:reward_4) { create(:reward, name: 'Airport Lounge Access') }

  describe '#perform' do
    context 'when SGD' do
      it 'creates transaction and award standard points' do
        expect do
          TransactionWorker.new.perform(user.id, 'SGD', 100, 'New purchase')
        end.to change { Transaction.count }.by(1)

        transaction = Transaction.first
        user.reload

        expect(transaction.amount).to eq(100)
        expect(transaction.currency).to eq('SGD')
        expect(transaction.description).to eq('New purchase')
        expect(user.points_cached).to eq(10)
      end
    end

    context 'when foreign' do
      it 'creates transaction and award double points' do
        expect do
          TransactionWorker.new.perform(user.id, 'BND', 100, 'New purchase')
        end.to change { Transaction.count }.by(1)

        transaction = Transaction.first
        user.reload

        expect(transaction.amount).to eq(100)
        expect(transaction.currency).to eq('BND')
        expect(transaction.description).to eq('New purchase')
        expect(user.points_cached).to eq(20)
      end
    end

    it 'create point records' do
      expect do
          TransactionWorker.new.perform(user.id, 'SGD', 100, 'New purchase')
      end.to change { Transaction.count }.by(1).
      and change { PointsRecord.count }.by(1)

      transaction = Transaction.first
      points_record = PointsRecord.first
      user.reload

      expect(points_record.user).to eq(user)
      expect(points_record.transaction_id).to eq(transaction.id)
      expect(points_record.amount).to eq(10)
      expect(points_record.description).to eq('New purchase')
    end

    context 'when user upgrades to gold' do
      before { user.update_columns(points_cached: 990) }

      it 'awards 4x airport lounge access reward' do
        expect do
          TransactionWorker.new.perform(user.id, 'SGD', 100, 'New purchase')
        end.to change { user.reload.rewards.count }.by(4)

        expect(user.tier).to eq('gold')
      end
    end

    context 'when user does not upgrade' do
      before { user.update_columns(points_cached: 90) }

      it 'does not issue anything' do
        expect do
          TransactionWorker.new.perform(user.id, 'SGD', 100, 'New purchase')
        end.to change { user.reload.rewards.count }.by(0)

        expect(user.tier).to eq('standard')
      end
    end
  end
end
