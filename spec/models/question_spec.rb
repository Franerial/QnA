require "rails_helper"

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name("User") }
  it { should belong_to(:best_answer).class_name("Answer").optional }

  describe "public methods" do
    let(:question) { create(:question_with_answers, answers_count: 5) }

    it "should set best answer" do
      question.set_best_answer(question.answers[2].id)
      expect(question.best_answer).to eq question.answers[2]
    end
  end

  it "have one attached file" do
    expect(Question.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
