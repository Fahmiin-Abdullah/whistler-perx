require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }

  describe '#create' do
    context 'when valid params' do
      it 'creates transaction and award standard points' do
        expect do
          post :create, params: { user_id: user.id, currency: 'SGD', amount: 100, description: 'New purchase' }
        end.to change(TransactionWorker.jobs, :size).by(1)
        expect(response).to have_http_status(200)
        expect(response.body).to eq('Transaction processed!')
      end
    end
  end
end
