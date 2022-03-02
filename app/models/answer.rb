class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: "User"
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  before_destroy :clear_best_answer
  after_create :send_notification

  def clear_best_answer
    question.update(best_answer_id: nil)
  end

  private

  def send_notification
    Notification.send_new_answer(self)
  end
end
