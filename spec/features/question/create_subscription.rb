require "rails_helper"

feature "User can subscribe for question", %q{
  In order to get new answers directly to email
  As an authenticated user
  I would like to be able to subscribe for question
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "tries to unsubscribe", js: true do
      within ".question-subscribed" do
        click_on "Subscribe"
        expect(page).to have_content "You are just subscribed to this question!"
        expect(page).to_not have_link "Subscribe"
      end
    end
  end

  describe "Unuthenticated user" do
    given(:question) { create(:question) }

    background { visit question_path(question) }

    scenario "can't unsubscribe", js: true do
      within ".question" do
        expect(page).to_not have_link "Subscribe"
      end
    end
  end
end
