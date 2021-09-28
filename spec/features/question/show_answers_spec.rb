require "rails_helper"

feature "User can view question and its answers", %q{
  Any user
  can view question and its answers
  to find the right answer to the corresponding question
} do
  given(:question) { create(:question_with_answers, answers_count: 5) }

  scenario "User view question and its answers list" do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content question.title

    expect(page.all("li").size).to eq question.answers.count
  end
end
