require "rails_helper"

feature "User can unsubscribe from question", %q{
  In order to stop getting new answers to email
  As an authenticated user
  I would like to be able to unsubscribe from question
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      question.subscriptions.create!(user: user)
      sign_in(user)

      visit question_path(question)
    end

    scenario "tries to subscribe", js: true do
      within ".question-subscribed" do
        click_on "Unsubscribe"
        expect(page).to have_content "You are just unsubscribed from this question!"
        expect(page).to_not have_link "Unsubscribe"
      end
    end
  end

  describe "Unuthenticated user" do
    given(:question) { create(:question) }

    background { visit question_path(question) }

    scenario "can't subscribe", js: true do
      within ".question" do
        expect(page).to_not have_link "Unsubscribe"
      end
    end
  end
end
