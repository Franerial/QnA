class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: "author_id", dependent: :destroy
  has_many :answers, foreign_key: "author_id", dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(post)
    (id == post.try(:author_id)) || (id == post.try(:user_id))
  end

  def find_vote(votable)
    Vote.find_by(user_id: id, votable_id: votable.id, votable_type: votable.class.name)
  end
end
