$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (event) {
    event.preventDefault();
    $(this).hide();

    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })
})

$(document).on('turbolinks:load', function () {
  $('.answers td.vote-link').on('ajax:success', processVote);

  $('.answers td.cancel-vote-link').on('ajax:success', function (event) {
    var rating = event.detail[0].rating;
    var answer_id = event.detail[0].votable_id;

    $('#answer-li-' + answer_id + ' td.cancel-vote-link').html('You have just canselled your vote!')
    $('#answer-li-' + answer_id + ' h4.vote-rating').html('Current rating: ' + rating);
  })
})

function processVote(event) {
  var vote = event.detail[0].vote;
  var rating = event.detail[0].rating;
  var answer_id = vote.votable_id;

  $('#answer-li-' + answer_id + ' td.vote-link').first().remove();
  $('#answer-li-' + answer_id + ' td.vote-link').last().html('<p> You ' + vote.status + ' this ' + vote.votable_type.toLowerCase() + '!</p>');
  $('#answer-li-' + answer_id + ' h4.vote-rating').html('Current rating: ' + rating);
}

export { processVote }
