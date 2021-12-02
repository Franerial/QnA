import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  var questionId = $(".question h3").attr('id');

  if (questionId) {
    consumer.subscriptions.create("CommentsChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log('connected to comments_channel!');
        this.perform('follow');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (gon.user_id != data.user_id) {
          $('#' + data.commentable_type + '-' + data.commentable_id + '-comments ul').append(data.comment_item)

          if (!$('#' + data.commentable_type + '-' + data.commentable_id + '-comments h4').length) {
            $('#' + data.commentable_type + '-' + data.commentable_id + '-comments').prepend("<h4> Comments: </h4>");
          }
        }
      }
    });
  }
})
