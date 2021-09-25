class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy]

  def new
    @answer = @question.answers.build ({ author_id: current_user.id })
  end

  def show
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author_id = current_user.id

    if @answer.save
      redirect_to @answer, notice: "Your answer successfully created."
    else
      @question.reload
      render "questions/show"
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: "Your answer was successfully deleted."
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
