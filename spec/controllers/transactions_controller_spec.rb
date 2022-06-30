require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }

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
    end
  end
end
