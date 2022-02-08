RSpec.shared_examples "API attachable" do
  before do
    file1 = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
    file2 = Rack::Test::UploadedFile.new("spec/spec_helper.rb")
    resource.files.attach(file1)
    resource.files.attach(file2)

    do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
  end

  let(:files_json) { json["#{resource.class.name.downcase}"]["files"] }
  let(:file_json) { files_json.first }

  it "returns list of files" do
    expect(files_json.size).to eq resource.files.size
  end

  it "returns files attributes" do
    expect(file_json["filename"]).to eq resource.files.first.filename.to_s
  end
end
