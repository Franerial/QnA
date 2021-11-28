import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  if ($(".questions-index-table").length) {
    consumer.subscriptions.create("QuestionsChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log('connected to questions_channel!');
        this.perform('follow');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        $(".questions-index-table").children().append(data.question_item)
      }
    });
  }
})
