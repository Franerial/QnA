RSpec.shared_examples "API linkable" do
  let!(:links) { create_list :link, 2, linkable: resource }
  let(:link) { links.first }

  before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

  let(:links_json) { json["#{resource.class.name.downcase}"]["links"] }
  let(:link_json) { links_json.first }

  it "returns list of links" do
    expect(links_json.size).to eq links.size
  end

  it "returns links attributes" do
    %w[id name url gist? created_at updated_at].each do |attr|
      expect(link_json[attr]).to eq link.send(attr).as_json
    end
  end
end
