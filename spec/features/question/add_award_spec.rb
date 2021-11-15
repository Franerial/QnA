require "rails_helper"

feature "User can attach award to question", %q{
  In order to provide more benefits to my question
  As an questions author
  I would like to be able to attach award
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario "User can attach one award when he creates question" do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"

    within ".award" do
      fill_in "Award name", with: "Test award"
      attach_file "Image", Rails.root.join("public/test-badge.png")
    end

    click_on "Ask"
    within ".question-award" do
      expect(page).to have_link "Test award"
    end
  end

  scenario "User tries attach invalid file" do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"

    within ".award" do
      fill_in "Award name", with: "Test award"
      attach_file "Image", Rails.root.join("#{Rails.root}/spec/spec_helper.rb")
    end

    click_on "Ask"

    expect(page).to have_content "Award image must be a URL for GIF, JPG or PNG image"
  end

  scenario "User tries to add award with invalid name" do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Text text text"

    within ".award" do
      fill_in "Award name", with: ""
      attach_file "Image", Rails.root.join("#{Rails.root}/spec/spec_helper.rb")
    end

    click_on "Ask"

    expect(page).to have_content "Award name can't be blank"
  end
end
