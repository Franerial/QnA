# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]

    can :update, [Question, Answer], author_id: user.id

    can :destroy, [Question, Answer, Link, ActiveStorage::Attachment], author_id: user.id
    can :destroy, Vote, user_id: user.id

    can :mark_as_best, Question, author_id: user.id
  end
end
