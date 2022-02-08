RSpec.shared_examples "API update resource" do
  describe "API resource owner is an owner of edited resource" do
    context "with valid params" do
      subject { do_request(method, api_path, params: valid_params.merge(access_token: access_token.token), headers: headers) }

      it "changes resource" do
        subject
        resource.reload
        valid_update_attributes.each do |attr_name, value|
          expect(resource.send(attr_name)).to eq value
        end
      end
    end

    context "with invalid params" do
      subject { do_request(method, api_path, params: invalid_params.merge(access_token: access_token.token), headers: headers) }

      it "does not change resource" do
        invalid_update_attributes.each_key do |attr_name|
          expect { subject }.not_to change(resource, attr_name)
        end
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

  describe "API resource owner is not an owner of edited resource" do
    before { resource.update_column :author_id, create(:user).id }

    subject { do_request(method, api_path, params: valid_params.merge(access_token: access_token.token), headers: headers) }

    it "does not change resource" do
      valid_update_attributes.each_key do |attr_name|
        expect { subject }.not_to change(resource, attr_name)
      end
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
