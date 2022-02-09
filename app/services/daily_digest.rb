class DailyDigest
  def send_digest
    questions = Question.where("DATE(created_at) = ?", Date.today - 1).to_a

    User.find_each(batch_size: 500) { |user| DailyDigestMailer.digest(user, questions).deliver_later }
  end
end
