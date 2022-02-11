class Notification
  def self.send_new_answer(answer)
    NotificationMailer.new_answer(answer.question.author, answer).deliver_later
  end
end
