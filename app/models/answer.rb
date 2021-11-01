class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  has_many_attached :files

  validates :body, presence: true

  before_destroy :clear_best_answer

  def clear_best_answer
    question.update(best_answer_id: nil)
  end
end
