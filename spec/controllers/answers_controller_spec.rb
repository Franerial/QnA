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

      it "render destroy view" do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    context "User is the author of answer" do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer, author: user) }

      context "with valid attributes" do
        it "changes answer attributes" do
          patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js
          answer.reload

          expect(answer.body).to eq "new body"
        end

        it "renders update view" do
          patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js

          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        it "does not change answer attributes" do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it "renders update view" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context "User is not the author of answer" do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer) }

      it "does not change answer attributes" do
        expect do
          patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js
        end.to_not change(answer, :body)
      end

      it "shows flash error message" do
        patch :update, params: { id: answer, answer: { body: "new body" } }, format: :js
        expect(flash[:notice]).to be_present
      end
    end
  end
end
