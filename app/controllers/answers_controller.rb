class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :set_answer, only: %i[destroy update]
  after_action :publish_answer, only: :create

  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author_id = current_user.id

    if @answer.save
      flash.now[:notice] = "Your answer successfully created."
    else
      @question.reload
    end
  end

  def update
    @answer.update(answer_params)
    flash.now[:notice] = "Your answer successfully updated."

    @question = @answer.question
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = "Your answer was successfully deleted."
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    answer_item = ApplicationController.render(
      partial: "answers/answer_pub",
      locals: { answer: @answer },
    )

    ActionCable.server.broadcast("question-#{@question.id}-answers", { answer_item: answer_item, user_id: @answer.author.id, answer_id: @answer.id, question_author_id: @question.author.id })
  end
end
