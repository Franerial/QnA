require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller do
  describe "POST #create" do
    subject(:http_request) { post :create, params: { question_id: question }, format: :js }

    let!(:question) { create :question }

    context "when authenticated user" do
      let(:user) { create :user }

      before { login(user) }

      it "creates new subscription for resource" do
        expect { http_request }.to change { question.subscriptions.count }.by(1)
      end

      it "creates new subscription for user" do
        expect { http_request }.to change { user.subscriptions.count }.by(1)
      end

      it { is_expected.to render_template(:create) }

      context "when subscription is present for user and resource" do
        before { question.subscriptions.create!(user: user) }

        it "does not create new subscription" do
          expect { http_request }.not_to change(Subscription, :count)
        end

        it { is_expected.to render_template(:create) }
      end
    end

    context "when unauthenticated user" do
      it "does not create new subscription" do
        expect { http_request }.not_to change(Subscription, :count)
      end

      it "returns unauthorized status" do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create :question }
    let(:user) { create :user }
    let(:user2) { create :user }
    before { question.subscriptions.create!(user: user) }

    subject(:http_request) { delete :destroy, params: { id: question.subscriptions.first, question_id: question.id }, format: :js }

    context "when authenticated user" do
      context "is the author of subscription" do
        before { login(user) }

        it "destroys the subscription for resource" do
          expect { http_request }.to change { question.subscriptions.count }.by(-1)
        end

        it "destroys the subscription for user" do
          expect { http_request }.to change { user.subscriptions.count }.by(-1)
        end

        it { is_expected.to render_template(:destroy) }
      end

      context "is not the author of subscription" do
        before { login(user2) }

        it "doesn't destroys the subscription for resource" do
          expect { http_request }.not_to change(Subscription, :count)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "when unauthenticated user" do
      it "does not change subscriptions count" do
        expect { http_request }.not_to change(Subscription, :count)
      end

      it "returns unauthorized status" do
        http_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
