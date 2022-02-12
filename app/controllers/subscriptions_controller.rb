class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(question: @question)
    authorize! :destroy, @subscription

    @subscription&.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
