class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id title body rating created_at updated_at]
  belongs_to :best_answer
  belongs_to :author
  has_many :answers
  has_many :links
  has_many :comments
  has_many :files, serializer: FileSerializer
end
