class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable, only: :create

  def create
    @vote = @votable.votes.build(user: current_user, status: params[:status]&.to_sym)

    respond_to do |format|
      if @vote.save
        format.json do
          render json: { vote: @vote, rating: @votable.rating }, status: :created
        end
      else
        format.json do
          render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.user == current_user
        @vote.destroy

        format.json do
          render json: { rating: @vote.votable.rating, votable_id: @vote.votable.id }, status: :ok
        end
      else
        format.json do
          head :forbidden
        end
      end
    end
  end

  private

  def find_votable
    @votable = params[:votable].constantize.find(params[:votable_id])
  end
end
