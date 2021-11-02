require "rails_helper"

feature "User can add links to question", %q{
  In order to provide additional info to my question
  As an questions author
  I would like to be able to add links
} do
  given(:user) { create(:user) }
  given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }

  scenario "User adds links when asks question" do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"
    fill_in "Link name", with: "Koala"
    fill_in "Url", with: img_url
    click_on "Ask"

    expect(page).to have_link "Koala", href: img_url
  end
end
