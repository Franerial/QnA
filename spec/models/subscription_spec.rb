require "rails_helper"

RSpec.describe Subscription, type: :model do
  subject { build :subscription }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to validate_uniqueness_of(:user).scoped_to(:question_id) }
end
