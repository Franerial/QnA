class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id body rating created_at updated_at]
  belongs_to :question
  belongs_to :author
  has_many :links
  has_many :comments
  has_many :files, serializer: FileSerializer
end
