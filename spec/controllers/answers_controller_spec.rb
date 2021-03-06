require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  before { login(user) }

  describe "POST #create" do
    let(:answer) { create(:answer) }
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context "with valid attributes" do
      it "saves a new answer into database" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it "render create view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
        expect(flash[:notice]).to be_present
      end

      it "broadcasts to answers channel" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to have_broadcasted_to("question-#{question.id}-answers").with(Answer.last)
      end
    end

    context "with invalid attributes" do
      it "doesn't save answer" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it "render create view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is the author" do
      let!(:answer) { create(:answer) }
      let (:user) { answer.author }

      it "deletes the answer" do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it "render destroy view" do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
        expect(flash[:notice]).to be_present
      end
    end

    context "User is not the author" do
      let (:user) { create(:user) }
      let!(:answer) { create(:answer) }

      it "answer was not deleted" do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it "should display flash notice" do
        delete :destroy, params: { id: answer }, format: :js
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    let (:user) { create(:user) }
    let(:question) { create(:question) }

    it_behaves_like "update resource" do
      let!(:resource) { create :answer, question: question, author: user }
      let(:update_attributes) { { body: "Edited answer" } }
      let(:invalid_attributes) { { body: " " } }
    end
  end
end
