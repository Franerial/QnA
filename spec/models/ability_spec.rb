require "rails_helper"

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let(:user_question) { create(:question, author: user) }
    let(:other_user_question) { create(:question, author: other_user) }

    before do
      file = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
      user_question.files.attach(file)
      other_user_question.files.attach(file)
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context "create abilities" do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Vote }
    end

    context "update abilities" do
      it { should be_able_to :update, create(:question, author: user) }
      it { should_not be_able_to :update, create(:question, author: other_user) }

      it { should be_able_to :update, create(:answer, author: user) }
      it { should_not be_able_to :update, create(:answer, author: other_user) }
    end

    context "destroy abilities" do
      it { should be_able_to :destroy, create(:question, author: user) }
      it { should_not be_able_to :destroy, create(:question, author: other_user) }

      it { should be_able_to :destroy, Answer }
      it { should_not be_able_to :destroy, create(:answer, author: other_user) }

      it { should be_able_to :destroy, user_question.files.first.record }
      it { should_not be_able_to :destroy, other_user_question.files.first.record }

      it { should be_able_to :destroy, create(:vote, user: user) }
      it { should_not be_able_to :destroy, create(:vote, user: other_user) }
    end

    context "custom abilities" do
      it { should be_able_to :mark_as_best, create(:question, author: user) }
      it { should_not be_able_to :mark_as_best, create(:question, author: other_user) }
    end
  end
end
