RSpec.shared_examples "API destroy resource" do
  subject { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

  describe "when resource owner is an author" do
    it "destroys resource" do
      expect { subject }.to change(resource_class, :count).by(-1)
      expect(resource_class).not_to exist(resource.id)
    end

    it "returns no content status" do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it "returns empty response" do
      subject
      expect(response.body).to be_empty
    end
  end

  describe "when resource owner is not an author" do
    before { resource.update_column :author_id, create(:user).id }

    it "doesn't destroy resource" do
      expect { subject }.not_to change(resource_class, :count)
      expect(resource_class).to exist(resource.id)
    end

    it "returns forbidden status" do
      subject
      expect(response).to have_http_status(:forbidden)
    end

    it "returns empty response" do
      subject
      expect(response.body).to be_empty
    end
  end
end
