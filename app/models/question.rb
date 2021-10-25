class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: "Answer", optional: true
  belongs_to :author, class_name: "User"

  validates :title, :body, presence: true

  def set_best_answer(answer_id)
    update!(best_answer_id: answer_id) if answer_ids.include?(answer_id&.to_i)
  end
end
