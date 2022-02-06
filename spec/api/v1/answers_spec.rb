require "rails_helper"

describe "Answers API", type: :request do
  let(:headers) do
    { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
  end

  describe "GET /api/v1/questions/:question_id/answers" do
    let!(:question) { create(:question_with_answers, answers_count: 3) }
    let(:answer) { question.answers.first }

    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :get }
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let(:question_answer_responce) { json["answers"].first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of question answers" do
        expect(json["answers"].size).to eq 3
      end

      it "returns all answers public fields" do
        %w[id body rating created_at updated_at].each do |attr|
          expect(question_answer_responce[attr]).to eq answer.send(attr).as_json
        end
      end

      it "contains question object" do
        expect(question_answer_responce["question"]["id"]).to eq question.id
      end

      it "contains user object" do
        expect(question_answer_responce["author"]["id"]).to eq answer.author.id
      end
    end
  end

  describe "GET /api/v1/answers/:id" do
    let!(:question) { create(:question_with_answers, answers_count: 3) }
    let(:answer) { question.answers.first }

    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let(:resource) { answer }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }

      it_behaves_like "API commentable"

      it_behaves_like "API linkable"

      it_behaves_like "API attachable"

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns all public answers fields" do
        %w[id body rating created_at updated_at].each do |attr|
          expect(json["answer"][attr]).to eq answer.send(attr).as_json
        end
      end

      it "contains question object" do
        expect(json["answer"]["question"]["id"]).to eq question.id
      end

      it "contains user object" do
        expect(json["answer"]["author"]["id"]).to eq answer.author.id
      end
    end
  end
end
