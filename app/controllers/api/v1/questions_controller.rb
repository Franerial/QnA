class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :load_question, only: :show

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionListSerializer
  end

  def show
    render json: @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
