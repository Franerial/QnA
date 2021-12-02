require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    describe "Authenticated user" do
      before { login(user) }

      context "with valid attributes" do
        it "creates new comment for question" do
          expect { post :create, params: { comment: { body: "Comment" }, commentable_id: question.id, commentable_type: question.class.name }, format: :js }.to change(question.comments, :count).by(1)
        end

        it "renders create view" do
          post :create, params: { comment: { body: "Comment" }, commentable_id: question.id, commentable_type: question.class.name }, format: :js
          expect(response).to render_template :create
        end
      end
      context "with invalid attributes" do
        it "doesn't save comment" do
          expect { post :create, params: { comment: { body: "" }, commentable_id: question.id, commentable_type: question.class.name }, format: :js }.to_not change(question.comments, :count)
        end

        it "renders create view" do
          post :create, params: { comment: { body: "" }, commentable_id: question.id, commentable_type: question.class.name }, format: :js
          expect(response).to render_template :create
        end
      end
    end
    describe "Unauthenticated user" do
      it "doesn't save comment" do
        expect { post :create, params: { comment: { body: "Comment" }, commentable_id: question.id, commentable_type: question.class.name }, format: :js }.to_not change(question.comments, :count)
      end
    end
  end
end
