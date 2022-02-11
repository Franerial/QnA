require "rails_helper"

RSpec.describe Notification do
  describe "self.send_new_answer" do
    let!(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question }

    it "sends new answer notification mail to owner of question" do
      expect(NotificationMailer).to receive(:new_answer).with(question.author, answer).and_call_original
      Notification.send_new_answer(answer)
    end
  end
end
