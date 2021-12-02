import consumer from "./consumer"
import { processVote } from 'answer.js';

$(document).on('turbolinks:load', function () {
  var questionId = $(".question h3").attr('id');

  if (questionId) {
    consumer.subscriptions.create("AnswersChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log('connected to answers_channel!');
        this.perform('start_stream_answers', { question_id: questionId.split("-").pop() });
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (gon.user_id != data.user_id) {
          $(".answers").children().append(data.answer_item)
          if (gon.user_id) {
            $('#answer-li-' + data.answer_id + ' td.vote-link').show();
            $('#answer-li-' + data.answer_id + ' td.vote-link').on('ajax:success', processVote);
          }

          if (gon.user_id == data.question_author_id) {
            $('#answer-li-' + data.answer_id + ' p.mark-best-link').show();
          }

        }
      }
    });
  }
})
