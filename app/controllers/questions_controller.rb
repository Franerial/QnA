class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :mark_as_best]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash.now[:notice] = "Your question successfully updated."
    else
      flash.now[:notice] = "You do not have permission to do that."
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Your question was successfully deleted."
    else
      redirect_to questions_path
    end
  end

  def mark_as_best
    if current_user.author_of?(@question)
      @question.set_best_answer(params[:answer_id])
      redirect_to @question
    else
      redirect_to @question, notice: "You do not have permission to do that."
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
