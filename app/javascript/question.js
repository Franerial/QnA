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
