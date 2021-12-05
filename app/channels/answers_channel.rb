class AnswersChannel < ApplicationCable::Channel
  def start_stream_answers(data)
    stream_from "question-#{data["question_id"]}-answers"
  end
end
