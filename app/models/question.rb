class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :best_answer, class_name: "Answer", optional: true
  belongs_to :author, class_name: "User"
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best_answer(answer_id)
    update!(best_answer_id: answer_id) if answer_ids.include?(answer_id&.to_i)
  end
end
