class AnswerListSerializer < ActiveModel::Serializer
  attributes %i[id body rating created_at updated_at]
  belongs_to :question
  belongs_to :author
end
