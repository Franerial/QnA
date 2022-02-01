class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable, only: :create
  before_action :set_vote, only: :destroy

  authorize_resource

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
    respond_to do |format|
      @vote.destroy

      format.json do
        render json: { rating: @vote.votable.rating, votable_id: @vote.votable.id }, status: :ok
      end
    end
  end

  private

  def find_votable
    @votable = params[:votable].constantize.find(params[:votable_id])
  end

  def set_vote
    @vote = Vote.find(params[:id])
  end
end
