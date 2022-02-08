require "rails_helper"

describe "Profiles API", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe "GET /api/v1/profiles/me" do
    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/profiles/me" }
      let(:method) { :get }
    end

    context "authorized" do
      before { get "/api/v1/profiles/me", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns all public fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it "doesn't return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe "GET /api/v1/profiles/all" do
    it_behaves_like "API Authorizable" do
      let(:api_path) { "/api/v1/profiles/all" }
      let(:method) { :get }
    end

    context "authorized" do
      let!(:users) { create_list :user, 2 }
      let(:user_responce) { json.first }

      before { get "/api/v1/profiles/all", params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns list of users" do
        expect(json.size).to eq users.size
      end

      it "returns all users without current user" do
        expect(json).to_not include(include(id: me.id))
      end

      it "returns all public fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_responce[attr]).to eq users.first.send(attr).as_json
        end
      end

      it "doesn't return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(user_responce).to_not have_key(attr)
        end
      end
    end
  end
end
