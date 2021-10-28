require "rails_helper"

feature "User can delete his attached files to answer" do
  describe "Authenticated user" do
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }

    describe "is the author of answer" do
      given(:user) { answer.author }

      background do
        sign_in(user)

        file = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
        answer.files.attach(file)

        visit question_path(question)
      end

      scenario "can delete" do
        within "#answer-li-#{answer.id}" do
          expect(page).to have_link "Remove"
          click_on "Remove"
          expect(page).to_not have_link "rails_helper.rb"
        end
      end
    end

    describe "is not the author of answer" do
      given(:user) { create(:user) }

      background do
        sign_in(user)

        file = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
        answer.files.attach(file)

        visit question_path(question)
      end

      scenario "can't delete" do
        within "#answer-li-#{answer.id}" do
          expect(page).to_not have_link "Remove"
        end
      end
    end
  end

  describe "Unauthenticated user" do
    given(:question) { create(:question) }
    given(:answer) { create(:answer, question: question) }

    background do
      file = Rack::Test::UploadedFile.new("spec/rails_helper.rb")
      answer.files.attach(file)

      visit question_path(question)
    end

    scenario "can't delete" do
      within "#answer-li-#{answer.id}" do
        expect(page).to_not have_link "Remove"
      end
    end
  end
end
