require "rails_helper"

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe "url format validations" do
    it { should_not allow_value("123").for(:url) }
    it { should allow_value("https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg").for(:url) }
  end

  describe "gist?" do
    let(:user) { create(:user) }

    context "return true" do
      let(:gist_link) { Link.new(name: "Gist link", url: "https://gist.github.com/Franerial/283ff0a5fd804d5f28c35047b01e305c", linkable: user) }

      it "link url matchs gist pattern" do
        expect(gist_link.gist?).to be true
      end
    end

    context "return false" do
      let(:link) { Link.new(name: "Link", url: "https://www.google.ru/", linkable: user) }

      it "link url does not match gist pattern" do
        expect(link.gist?).to be false
      end
    end
  end
end
