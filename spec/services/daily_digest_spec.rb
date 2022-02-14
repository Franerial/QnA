require "rails_helper"

RSpec.describe DailyDigest do
  let(:users) { create_list(:user, 2) }

  let!(:before_yesterday_question) { create :question, created_at: 2.days.ago, author: users.first }

  let!(:yesterday_questions) { create_list :question, 2, created_at: 20.hours.ago, author: users.last }

  it "sends daily digest to all users with yesterday questions" do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, yesterday_questions).and_call_original }
    subject.send_digest
  end
end
