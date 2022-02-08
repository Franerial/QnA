class QuestionListSerializer < ActiveModel::Serializer
  attributes %i[id title body rating created_at updated_at short_title]
  belongs_to :author
  belongs_to :best_answer

  def short_title
    object.title.truncate(7)
  end
end
