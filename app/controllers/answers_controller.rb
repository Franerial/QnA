class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: :create
  before_action :set_answer, only: %i[show destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author_id = current_user.id

    if @answer.save
      #redirect_to @question, notice: "Your answer successfully created."
      flash.now[:notice] = "Your answer successfully created."
    else
      @question.reload
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: "Your answer was successfully deleted."
    else
      redirect_to question_path(@answer.question)
    end
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
