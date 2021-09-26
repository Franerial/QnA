require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  describe "POST #create" do
    let(:answer) { create(:answer) }
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    before { login(user) }

    context "with valid attributes" do
      it "saves a new answer into database" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it "redirect to question show view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid attributes" do
      it "doesn't save answer" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it "re-render show question page" do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is the author" do
      let!(:answer) { create(:answer) }
      let (:user) { answer.author }

      before { login(user) }

      it "deletes the answer" do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it "redirects to corresponding question" do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
        expect(flash[:notice]).to be_present
      end
    end

    context "User is not the author" do
      let (:user) { create(:user) }
      let!(:answer) { create(:answer) }

      before { login(user) }

      it "redirects to corresponding question" do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
