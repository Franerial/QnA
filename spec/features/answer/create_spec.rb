require "rails_helper"

feature "User can create answer", %q{
  An authenticated user
  can create an answer to the corresponded question created by other users
  to help to solve their problems
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Create answer", js: true do
      fill_in "Body", with: "Text text text"
      click_on "Create"

      expect(page).to have_content "Your answer successfully created."
      expect(page).to have_content "Text text text"
    end

    scenario "Create answer with errors", js: true do
      click_on "Create"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "create answer with attached files", js: true do
      fill_in "Body", with: "Text text text"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Create"

      within ".answers" do
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
  end

  scenario "Unauthenticated user try to create answer" do
    visit question_path(question)
    click_on "Create"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
