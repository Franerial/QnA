require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it "populate an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "assigns new answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe "GET #new" do
    before { login(user) }

    before { get :new }

    it "assigns a new question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "saves a new question into database" do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it "redirect to show view" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid attributes" do
      it "doesn't save question" do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it "re-render new form" do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before { login(user) }

    context "User is the author of question" do
      let!(:question) { create(:question, author: user) }

      context "with valid attributes" do
        it "assigns the requested question to @question" do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it "changes question attributes" do
          patch :update, params: { id: question, question: { title: "new title", body: "new body" } }, format: :js
          question.reload

          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end

        it "render update view" do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it "does not change question" do
          question.reload

          expect(question.title).to eq "MyString"
          expect(question.body).to eq "MyText"
        end

        it "render update view" do
          expect(response).to render_template :update
        end
      end
    end

    context "User is not the author of question" do
      it "does not change question attributes" do
        expect do
          patch :update, params: { id: question, question: { body: "new body" } }, format: :js
        end.to_not change(question, :body)
      end

      it "shows flash error message" do
        patch :update, params: { id: question, question: { body: "new body" } }, format: :js
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is the author" do
      let!(:question) { create(:question) }
      let (:user) { question.author }

      before { login(user) }

      it "deletes the question" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to be_present
      end
    end

    context "User is not the author" do
      let!(:question) { create(:question) }
      let (:user) { create(:user) }

      before { login(user) }

      it "question was not deleted" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it "redirects to index" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe "PATCH #mark_as_best" do
    let(:question) { create(:question) }
    let (:answer) { create(:answer, question: question) }

    context "User is the author of question" do
      let (:user) { question.author }

      before do
        login(user)
        patch :mark_as_best, params: { id: question, answer_id: answer }
      end

      it "should set best answer for question" do
        question.reload
        expect(question.best_answer).to eq answer
      end

      it "should redirect to question" do
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "User is not the author of question" do
      let (:user) { create(:user) }

      before do
        login(user)
        patch :mark_as_best, params: { id: question, answer_id: answer }
      end

      it "should not set best answer for question" do
        question.reload
        expect(question.best_answer).to be nil
      end

      it "should redirect to question with notice" do
        expect(question.set_best_answer(answer.id)).to eq nil
        expect(flash[:notice]).to be_present
      end
    end
  end
end
