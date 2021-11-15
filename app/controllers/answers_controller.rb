class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: :create
  before_action :set_answer, only: %i[show destroy update]

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
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = "Your answer successfully updated."
    else
      flash.now[:notice] = "You do not have permission to do that."
    end

    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = "Your answer was successfully deleted."
    else
      flash.now[:notice] = "You do not have permission to do that."
    end
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
end
