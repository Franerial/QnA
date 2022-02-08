class Api::V1::AnswersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :load_answer, only: [:show, :update, :destroy]
  before_action :find_question, only: [:index, :create]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerListSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author_id = current_resource_owner.id

    save_and_render @answer, :created
  end

  def update
    @answer.attributes = answer_params

    save_and_render @answer, :ok
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
