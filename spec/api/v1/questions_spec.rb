require "rails_helper"

describe "Questions API", type: :request do
  let(:headers) do
    { "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
  end

  describe "GET /api/v1/questions" do
    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/questions" }
      let(:method) { :get }
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_responce) { json["questions"].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get "/api/v1/questions", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of qustions" do
        expect(json["questions"].size).to eq 2
      end

      it "returns all public fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_responce[attr]).to eq question.send(attr).as_json
        end
      end

      it "contains user object" do
        expect(question_responce["author"]["id"]).to eq question.author.id
      end

      it "contains short title" do
        expect(question_responce["short_title"]).to eq question.title.truncate(7)
      end

      describe "answers" do
        let(:answer) { answers.first }
        let(:answer_responce) { question_responce["answers"].first }

        it "returns list of answers" do
          expect(question_responce["answers"].size).to eq 3
        end

        it "returns all public fields" do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_responce[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let!(:question) { create(:question) }

    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
    end

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let(:resource) { question }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }

      it_behaves_like "API commentable"

      it_behaves_like "API linkable"

      it_behaves_like "API attachable"

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns all question fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(json["question"][attr]).to eq question.send(attr).as_json
        end
      end
    end
  end
end
