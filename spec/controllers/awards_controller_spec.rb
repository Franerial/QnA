require "rails_helper"

RSpec.describe AwardsController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user_with_awards, awards_count: 5) }

    before do
      login(user)
      get :index
    end

    it "populate an array of all awards" do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end
end
