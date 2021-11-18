require "rails_helper"

feature "User can vote for answer", %q{
  In order to express my opinion for the specific answer
  As an authenticated user
  I would like to be able to vote for that answer
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given!(:question) { create(:question_with_answers, answers_count: 5) }
    given!(:answer) { question.answers[2] }
    given!(:answer2) { question.answers[3] }
    given!(:answer3) { question.answers[4] }
    given!(:vote) { create(:vote, votable: answer3, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "like answer", js: true do
      within "#answer-li-#{answer.id}" do
        click_on "Like"
        expect(page).to have_content "You like this answer!"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"

        expect(page).to have_content "Current rating: 1"
      end
    end

    scenario "dislike answer", js: true do
      within "#answer-li-#{answer2.id}" do
        click_on "Dislike"
        expect(page).to have_content "You dislike this answer!"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"

        expect(page).to have_content "Current rating: -1"
      end
    end

    scenario "can't vote twice for answer", js: true do
      within "#answer-li-#{answer3.id}" do
        expect(page).to have_link "Cancel vote"
        expect(page).to_not have_link "Dislike"
        expect(page).to_not have_link "Like"
      end
    end
  end

  describe "Unauthenticated user" do
    given!(:question) { create(:question_with_answers, answers_count: 5) }
    given!(:answer) { question.answers[2] }

    scenario "can't vote" do
      visit question_path(question)

      within "#answer-li-#{answer.id}" do
        expect(page).to_not have_css(".answer-vote table")
      end
    end
  end
end
