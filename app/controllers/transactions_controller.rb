class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    TransactionWorker.perform_async(transaction_params[:user_id].to_i,
                                    transaction_params[:currency],
                                    transaction_params[:amount].to_f,
                                    transaction_params[:description])

    render json: 'Transaction processed!', status: :ok
  end

  private

  def transaction_params
    params.require(%i[user_id currency amount])
    params.permit(:user_id, :currency, :amount, :description)
  end
end
