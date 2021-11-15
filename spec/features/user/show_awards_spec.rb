require "rails_helper"

feature "User can view his awards" do
  describe "Authenticated user" do
    given(:user_with_awards) { create(:user_with_awards, awards_count: 5) }
    given(:user_without_awards) { create(:user) }

    scenario "has awards" do
      sign_in(user_with_awards)
      visit awards_path
      expect(page.all("tr").size - 1).to eq user_with_awards.awards.count
    end

    scenario "has no awards" do
      sign_in(user_without_awards)
      visit awards_path
      expect(page).to have_content "No awards yet"
    end
  end

  describe "Unauthenticated user" do
    scenario "no access to view awards link" do
      visit questions_path
      expect(page).not_to have_link "View Awards"
    end
  end
end
