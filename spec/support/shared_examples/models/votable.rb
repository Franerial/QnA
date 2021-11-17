RSpec.shared_examples "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  describe "rating" do
    let(:votable_object) { create(described_class.to_s.underscore.to_sym) }
    context "when object has no votes" do
      it "returns zero" do
        expect(votable_object.rating).to eq 0
      end
    end

    context "when object has some votes" do
      let!(:like_votes) { create_list :vote, 3, status: :like, votable: votable_object }
      let!(:dislike_votes) { create_list :vote, 2, status: :dislike, votable: votable_object }

      it "should return calculated rating" do
        expect(votable_object.rating).to eq 1
      end
    end
  end
end
