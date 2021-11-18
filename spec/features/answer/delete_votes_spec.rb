require "rails_helper"

feature "User can delete his vote for answer", %q{
  In order to change my opinion for the specific answer
  As an authenticated user
  I would like to be able to delete my vote that answer
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given!(:question) { create(:question_with_answers, answers_count: 5) }
    given!(:answer) { question.answers[2] }
    given!(:vote) { create(:vote, votable: answer, user: user, status: :dislike) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "deletes his vote for answer", js: true do
      within "#answer-li-#{answer.id}" do
        accept_confirm do
          click_on "Cancel vote"
        end

        expect(page).to have_content "You have just canselled your vote!"
        expect(page).to have_content "Current rating: 0"
      end
    end
  end

  describe "Unauthenticated user" do
    given!(:question) { create(:question_with_answers, answers_count: 5) }
    given!(:answer) { question.answers[2] }

    scenario "can't delete vote" do
      visit question_path(question)

      within "#answer-li-#{answer.id}" do
        expect(page).to_not have_css(".answer-vote table")
      end
    end
  end
end
