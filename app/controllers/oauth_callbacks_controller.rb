class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    #render json: request.env["omniauth.auth"]
    @user = User.find_for_oauth(request.env["omniauth.auth"])

    redirect_user("Github")
  end

  def vkontakte
    @user = User.find_for_oauth(request.env["omniauth.auth"])

    return redirect_to edit_user_path(@user) if @user && @user.email.blank?

    redirect_user("Vkontakte")
  end

  private

  def redirect_user(kind)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end
end
