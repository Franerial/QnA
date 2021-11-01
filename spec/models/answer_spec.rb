require "rails_helper"

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name("User") }

  describe "public methods" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it "should clear best answer" do
      question.best_answer = answer
      answer.clear_best_answer
      expect(question.best_answer).to be nil
    end
  end

  it "has many attached files" do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
