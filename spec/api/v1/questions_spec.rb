require "rails_helper"

describe "Questions API", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let(:resource_class) { Question }

  describe "GET /api/v1/questions" do
    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/questions" }
      let(:method) { :get }
    end

    context "authorized" do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_responce) { json["questions"].first }

      before { get "/api/v1/questions", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of questions" do
        expect(json["questions"].size).to eq 2
      end

      it "returns all questions public fields" do
        %w[id title body rating created_at updated_at].each do |attr|
          expect(question_responce[attr]).to eq question.send(attr).as_json
        end
      end

      it "contains user object" do
        expect(question_responce["author"]["id"]).to eq question.author.id
      end

      it "contains short title" do
        expect(question_responce["short_title"]).to eq question.title.truncate(7)
      end

      it "contains best answer object" do
        expect(question_responce["best_answer"]).to eq question.best_answer
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like "API Authorizable"

    context "authorized" do
      let(:resource) { question }

      it_behaves_like "API commentable"

      it_behaves_like "API linkable"

      it_behaves_like "API attachable"

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns all public question fields" do
        %w[id title body rating created_at updated_at].each do |attr|
          expect(json["question"][attr]).to eq question.send(attr).as_json
        end
      end

      it "contains user object" do
        expect(json["question"]["author"]["id"]).to eq question.author.id
      end

      it "contains best answer object" do
        expect(json["question"]["best_answer"]).to eq question.best_answer
      end

      describe "answers" do
        let!(:answers) { create_list(:answer, 3, question: question) }
        let(:answer) { answers.first }
        let(:question_responce) { json["question"] }
        let(:answer_responce) { question_responce["answers"].first }

        before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

        it "returns list of answers" do
          expect(question_responce["answers"].size).to eq 3
        end

        it "returns all answers public fields" do
          %w[id body rating created_at updated_at].each do |attr|
            expect(answer_responce[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }

    it_behaves_like "API Authorizable"

    it_behaves_like "API create resource" do
      let(:valid_params) { { question: attributes_for(:question) } }
      let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:resource) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:method) { :patch }

    it_behaves_like "API Authorizable"

    it_behaves_like "API update resource" do
      let(:valid_update_attributes) { { title: "Edited title", body: "Edited body" } }
      let(:valid_params) { { question: valid_update_attributes } }

      let(:invalid_update_attributes) { { title: "Edited title", body: "" } }
      let(:invalid_params) { { question: invalid_update_attributes } }
    end
  end

  describe "DELETE /api/v1/questions/:id" do
    let!(:resource) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:method) { :delete }

    it_behaves_like "API Authorizable"

    it_behaves_like "API destroy resource"
  end
end
