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

      it "user is the author of question" do
        expect(user).to be_author_of(question)
      end
    end

    context "return false" do
      let(:question) { create(:question) }

      it "user is not the author of question" do
        expect(user).not_to be_author_of(question)
      end
    end
  end
end
