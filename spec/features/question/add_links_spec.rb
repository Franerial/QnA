require "rails_helper"

feature "User can add links to question", %q{
  In order to provide additional info to my question
  As an questions author
  I would like to be able to add links
} do
  given(:user) { create(:user) }
  given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }
  given (:gem_url) { "https://rubygems.org/gems/cocoon" }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario "User adds links when asks question", js: true do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"
    fill_in "Link name", with: "Koala"
    fill_in "Url", with: img_url

    click_on "Add link"

    within all(".nested-fields").last do
      fill_in "Link name", with: "Cocoon gem"
      fill_in "Url", with: gem_url
    end

    click_on "Ask"

    within(".question-links") do
      expect(page).to have_link "Koala", href: img_url
      expect(page).to have_link "Cocoon gem", href: gem_url
    end
  end

  scenario "User adds links with errors when asks question", js: true do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"
    fill_in "Link name", with: "Koala"
    fill_in "Url", with: "123"

    click_on "Ask"

    expect(page).to have_content "Links url is invalid"
  end
end
