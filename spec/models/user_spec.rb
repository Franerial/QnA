require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }

  describe "author_of?" do
    let(:user) { create(:user) }

    context "return true" do
      let(:question) { create(:question, author: user) }
      let(:vote) { create(:vote, user: user) }

      it "user is the author of question" do
        expect(user.author_of?(question)).to be_truthy
      end

      it "user is the author of vote" do
        expect(user.author_of?(vote)).to be_truthy
      end
    end

    context "return false" do
      let(:question) { create(:question) }
      let(:vote) { create(:vote) }

      it "user is not the author of question" do
        expect(user.author_of?(question)).to be_falsey
      end

      it "user is not the author of vote" do
        expect(user.author_of?(vote)).to be_falsey
      end
    end
  end

  describe "find_vote" do
    let(:user) { create(:user) }

    context "return vote" do
      let(:question) { create(:question) }
      let!(:vote) { create(:vote, user: user, votable: question) }

      it "user has vote for question" do
        expect(user.find_vote(question)).to eq vote
      end
    end

    context "return nil" do
      let(:question) { create(:question) }
      let!(:vote) { create(:vote, user: user) }

      it "user has no vote for question" do
        expect(user.find_vote(question)).to be_nil
      end
    end
  end
end
