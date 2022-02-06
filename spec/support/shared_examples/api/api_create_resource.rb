RSpec.shared_examples "API create resource" do
  describe "authorized" do
    let(:user) { User.find(access_token.resource_owner_id) }

    context "with valid params" do
      subject { do_request(method, api_path, params: valid_params.merge(access_token: access_token.token), headers: headers) }

      it "creates new resource" do
        expect { subject }.to change(resource_class, :count).by(1)
      end

      it "sets user attribute to resource owner" do
        subject

        expect(resource_class.last.author).to eq user
      end
    end

    context "with invalid params" do
      subject { do_request(method, api_path, params: invalid_params.merge(access_token: access_token.token), headers: headers) }

      it "does not create new resource" do
        expect { subject }.not_to change(resource_class, :count)
      end

      it "returns unprocessable entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors in json" do
        subject
        expect(json["errors"]).to be_present
      end
    end
  end
end
