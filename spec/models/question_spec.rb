require "rails_helper"

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:author).class_name("User") }
  it { should belong_to(:best_answer).class_name("Answer").optional }
  it { should have_one(:award).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it_behaves_like "votable"
  it_behaves_like "commentable"

  describe "public methods" do
    let(:question) { create(:question_with_answers, answers_count: 5) }
    let!(:award) { create(:award, question: question) }

    it "should set best answer and give award" do
      question.set_best_answer(question.answers[2].id)
      expect(question.best_answer).to eq question.answers[2]
      expect(question.answers[2].author.awards.first).to eq award
    end
  end

  it "has many attached files" do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
