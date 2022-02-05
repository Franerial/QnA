class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id title body created_at updated_at]
  has_many :links
  has_many :comments
  has_many :files, serializer: FileSerializer
end
