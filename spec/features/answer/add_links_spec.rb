require "rails_helper"

feature "User can add links to answer", %q{
  In order to provide additional info to my answer
  As an questions author
  I would like to be able to add links
} do
  given(:user) { create(:user) }
  given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }
  given(:question) { create(:question) }

  scenario "User adds links when create answer", js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Body", with: "Text text text"
    fill_in "Link name", with: "Koala"
    fill_in "Url", with: img_url
    click_on "Create"

    within ".answers" do
      expect(page).to have_link "Koala", href: img_url
    end
  end
end
