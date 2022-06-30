require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:reward_1) { create(:reward, name: 'Free Coffee') }
  let!(:reward_2) { create(:reward, name: '5% Cash Rebate') }
  let!(:reward_3) { create(:reward, name: 'Free Movie Tickets') }

  describe '#create' do
    context 'when valid params' do
      context 'when SGD' do
        it 'creates transaction and award standard points' do
          expect do
            post :create, params: { user_id: user.id, currency: 'SGD', amount: 100, description: 'New purchase' }
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
            post :create, params: { user_id: user.id, currency: 'BND', amount: 100, description: 'New purchase' }
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
          post :create, params: { user_id: user.id, currency: 'SGD', amount: 100, description: 'New purchase' }
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
    end
  end
end
