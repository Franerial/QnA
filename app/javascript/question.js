$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-title-link', function (event) {
    event.preventDefault();
    $(this).hide();

    var questionId = $(this).data('questionId');
    $('form#edit-question-title-' + questionId).show();
  })
})

$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-body-link', function (event) {
    event.preventDefault();
    $(this).hide();

    var questionId = $(this).data('questionId');
    $('form#edit-question-body-' + questionId).show();
  })
})

$(document).on('turbolinks:load', function () {
  $('.question td.vote-link').on('ajax:success', function (event) {

    vote = event.detail[0].vote;
    rating = event.detail[0].rating;

    $('.question td.vote-link').first().remove();
    $('.question td.vote-link').last().html('<p> You ' + vote.status + ' this ' + vote.votable_type.toLowerCase() + '!</p>');
    $('.question h4.vote-rating').html('Current rating: ' + rating);
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.question-errors').append('<p>' + value + '</p>');
      })

    })

  $('.question td.cancel-vote-link').on('ajax:success', function (event) {
    rating = event.detail[0].rating;

    $('.question td.cancel-vote-link').html('You have just canselled your vote!')
    $('.question h4.vote-rating').html('Current rating: ' + rating);
  })
})

$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.add-comment', function (event) {
    event.preventDefault();
    $(this).hide();

    var questionId = $(this).data('questionId');

    $('#question-' + questionId + '-comments form').show();
    $('#question-' + questionId + '-comments form textarea').val('');
  })
})
