class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: [:show, :update, :destroy, :mark_as_best]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer.links.build
  end

  def new
    @question = current_user.questions.build
    @question.links.build
    @question.build_award
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
    @question.update(question_params)
    flash.now[:notice] = "Your question successfully updated."
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "Your question was successfully deleted."
  end

  def mark_as_best
    @question.set_best_answer(params[:answer_id])
    redirect_to @question
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], award_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.any?

    question_item = ApplicationController.render(
      partial: "questions/question",
      locals: { question: @question },
    )

    ActionCable.server.broadcast("questions", { question_item: question_item })
  end
end
