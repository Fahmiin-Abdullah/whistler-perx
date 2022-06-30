class TransactionsController < ApplicationController
  before_action :set_user
  skip_before_action :verify_authenticity_token

  def create
    points = PointsService.new(transaction_params[:currency], transaction_params[:amount]).calculate_points
    @user.with_lock do
      transaction = Transaction.create!(transaction_params)
      PointsRecord.create!(user: @user, transaction_id: transaction.id, amount: points, description: transaction_params[:description])
      @user.points_cached += points
      @user.save!
      RewardsService.new(@user).issue_rewards
    end

    render json: 'Transaction processed successfully!', status: :ok
  end

  private

  def set_user
    @user = User.find(transaction_params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def transaction_params
    params.require(%i[user_id currency amount])
    params.permit(:user_id, :currency, :amount, :description)
  end
end
