require "rails_helper"

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "Github" do
    let (:oauth_data) { { "provider" => "github", "uid" => 123 } }

    it "finds user from auth data" do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with("omniauth.auth").and_return(oauth_data)

      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context "user exists" do
      let! (:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it "login user if it exists" do
        expect(subject.current_user).to eq user
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "user doesn't exists" do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end

      it "doesn't login user" do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe "Vkontakte" do
    let (:oauth_data) { { "provider" => "vkontakte", "uid" => 123 } }

    it "finds user from auth data" do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with("omniauth.auth").and_return(oauth_data)

      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context "user exists" do
      let! (:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it "login user if it exists" do
        expect(subject.current_user).to eq user
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end

      context "user has blank email" do
        let! (:user) { create(:user) }

        it "redirects to set email page" do
          user.email = ""
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :vkontakte

          expect(response).to redirect_to edit_user_path(user)
        end
      end
    end

    context "user doesn't exists" do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end

      it "doesn't login user" do
        expect(subject.current_user).to_not be
      end
    end
  end
end
