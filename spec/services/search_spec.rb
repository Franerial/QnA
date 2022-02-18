require "rails_helper"

RSpec.describe Search do
  let(:query) { "MyQuery" }
  let(:questions) { create_list(:question, 2) }
  let(:answers) { create_list(:answer, 2) }
  let(:users) { create_list(:user, 2) }
  let(:comments) { create_list(:comment, 2, user: users.first, commentable: questions.first) }

  before do
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Question, Comment]).and_return(questions + comments)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Question]).and_return(questions)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Comment]).and_return(comments)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [Answer]).and_return(answers)
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [User]).and_return(users)
  end

  context "questions only search" do
    it_behaves_like "search by single class" do
      let(:resource_class) { Question }
      let(:resource_class_name) { Question.to_s.underscore }
    end
  end

  context "answers only search" do
    it_behaves_like "search by single class" do
      let(:resource_class) { Answer }
      let(:resource_class_name) { Answer.to_s.underscore }
    end
  end

  context "users only search" do
    it_behaves_like "search by single class" do
      let(:resource_class) { User }
      let(:resource_class_name) { User.to_s.underscore }
    end
  end

  context "comments only search" do
    it_behaves_like "search by single class" do
      let(:resource_class) { Comment }
      let(:resource_class_name) { Comment.to_s.underscore }
    end
  end

  context "includes several resources" do
    subject { Search.new(query, %w[question comment]) }

    it "calls search method of ThinkingSphinx with query and all searchable classes" do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [Question, Comment])
      subject.call
    end

    it "returns found results" do
      expect(subject.call).to eq questions + comments
    end
  end
end
