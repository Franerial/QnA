require "rails_helper"

feature "User can sign in with omniauth" do
  background { visit new_user_session_path }

  describe "Sign in with Vkontakte" do
    background { mock_auth_hash(:vkontakte) }

    describe "When Vkontakte account has email" do
      scenario "user can sign in with Vkontakte account" do
        click_on "Sign in with Vkontakte"

        expect(page).to have_content("Successfully authenticated from Vkontakte account")
        expect(page).to have_link "Logout"
      end

      scenario "can handle authentication error" do
        OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
        click_on "Sign in with Vkontakte"

        expect(page).to have_content("Could not authenticate you from Vkontakte")
      end
    end

    describe "When Vkontakte account hasn't email" do
      background do
        OmniAuth.config.mock_auth[:vkontakte]["info"]["email"] = ""
      end

      context "user hasn't filled email yet" do
        context "fills valid email" do
          background do
            clear_emails
            click_on "Sign in with Vkontakte"
            fill_in "Email", with: "user@email.com"
            click_on "Register email"
          end

          scenario "user doesn't sign in and get message about confirmation" do
            expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account")
            expect(page).not_to have_link("Logout")
          end

          scenario "user receive confirmation email in his mailbox" do
            open_email("user@email.com")

            expect(current_email).to have_link "Confirm my account"
            expect(current_email.body).to have_content "Welcome user@email.com!"
          end

          scenario "user can sign in after account confirmation" do
            open_email("user@email.com")
            current_email.click_link "Confirm my account"
            expect(page).to have_content "Your email address has been successfully confirmed"

            click_on "Sign in with Vkontakte"

            expect(page).to have_content("Successfully authenticated from Vkontakte account")
            expect(page).to have_content("Logout")
          end
        end

        context "fills invalid email" do
          scenario "user fills invalid data in email field" do
            click_on "Sign in with Vkontakte"
            fill_in "Email", with: " "
            click_on "Register email"

            expect(page).to have_content("Email can't be blank")
            expect(page).not_to have_content("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account")
          end
        end
      end
    end

    describe "user has already filled email" do
      given(:user) { create :user }

      background do
        user.authorizations.create!(provider: "vkontakte", uid: OmniAuth.config.mock_auth[:vkontakte]["uid"])
      end

      context "when user has confirmed his email" do
        scenario "user can sign in with Vkontakte account" do
          click_on "Sign in with Vkontakte"

          expect(page).to have_content("Successfully authenticated from Vkontakte account")
          expect(page).to have_content("Logout")
        end
      end

      context "when user hasn't confirmed his email" do
        background { user.update!(confirmed_at: nil) }

        scenario "user can't't sign in with Vkontakte account" do
          click_on "Sign in with Vkontakte"

          expect(page).not_to have_content("Successfully authenticated from Vkontakte account")
          expect(page).not_to have_content("Logout")
          expect(page).to have_content("You have to confirm your email address before continuing")
        end
      end
    end
  end
end
