class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :load_question, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionListSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.build(question_params)

    save_and_render @question, :created
  end

  def update
    @question.attributes = question_params

    save_and_render @question, :ok
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url], award_attributes: [:name, :image])
  end
end
