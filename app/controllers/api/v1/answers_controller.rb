class Api::V1::AnswersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :load_answer, only: :show
  before_action :find_question, only: :index

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerListSerializer
  end

  def show
    render json: @answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
