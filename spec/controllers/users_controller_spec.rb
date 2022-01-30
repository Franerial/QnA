require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #edit" do
    let!(:user) { create :user }

    before { get :edit, params: { id: user } }

    it "assigns the requested user to @user" do
      expect(assigns(:user)).to eq user
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    let!(:user) { create :user }

    context "with valid email" do
      before { patch :update, params: { id: user, user: { email: "user@yandex.ru" } } }

      it "updates user email" do
        expect(user.reload.email).to eq "user@yandex.ru"
      end

      it "should send a confirmation email to the user" do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid email" do
      before { patch :update, params: { id: user, user: { email: "" } } }

      it "does not update user email" do
        expect(user.reload.email).to eq user.email
      end

      it "shouldn't send a confirmation email to the user" do
        expect { patch :update, params: { id: user, user: { email: "" } } }.to_not change(ActionMailer::Base.deliveries, :count)
      end

      it "re-render edit view" do
        expect(response).to render_template :edit
      end
    end
  end
end
