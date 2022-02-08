RSpec.shared_examples "API commentable" do
  let(:user) { create(:user) }
  let!(:comments) { create_list :comment, 2, commentable: resource, user: user }
  let(:comment) { comments.first }

  before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

  let(:comments_json) { json["#{resource.class.name.downcase}"]["comments"] }
  let(:comment_json) { comments_json.first }

  it "returns list of comments" do
    expect(comments_json.size).to eq comments.size
  end

  it "returns comments attributes" do
    %w[id body created_at updated_at].each do |attr|
      expect(comment_json[attr]).to eq comment.send(attr).as_json
    end
  end

  it "returns comments author" do
    expect(comment_json["user"]["id"]).to eq comment.user.id
    expect(comment_json["user"]["email"]).to eq comment.user.email
  end
end
