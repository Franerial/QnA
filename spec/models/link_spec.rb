require "rails_helper"

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context "url format validations" do
    it { should_not allow_value("123").for(:url) }
    it { should allow_value("https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg").for(:url) }
  end
end
