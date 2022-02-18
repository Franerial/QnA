RSpec.shared_examples "search by single class" do
  let(:results) { resource_class.table_name }

  subject { Search.new(query, [resource_class_name]) }

  it "calls search method of ThinkingSphinx with query and classes with search Class" do
    expect(ThinkingSphinx).to receive(:search).with(query, classes: [resource_class])
    subject.call
  end

  it "returns found results" do
    allow(ThinkingSphinx).to receive(:search).with(query, classes: [resource_class]).and_return(results)
    expect(subject.call).to eq results
  end
end
