require "rails_helper"

feature "User can view questions list", %q{
  Any user
  can look at the general list of questions
  to find the question of interest
} do
  background { create_list(:question, 3) }

  scenario "User view questions list" do
    visit questions_path

    expect(page).to have_content "Questions list"
    expect(page.all("td", text: "MyText").size).to eq Question.count
  end
end
