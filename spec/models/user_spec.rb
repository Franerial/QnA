require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe "author_of?" do
    let(:user) { create(:user) }

    context "return true" do
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, author: user) }

      it "user is the author of question" do
        expect(user.author_of?(question)).to be(true)
      end

      it "user is author of answer" do
        expect(user.author_of?(answer)).to be(true)
      end
    end

    context "return false" do
      let(:question) { create(:question) }
      let(:answer) { create(:answer) }

      it "user is not the author of question" do
        expect(user.author_of?(question)).to be(false)
      end

      it "user is not author of answer" do
        expect(user.author_of?(answer)).to be(false)
      end
    end
  end
end
