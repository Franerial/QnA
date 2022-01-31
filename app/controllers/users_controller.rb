class UsersController < ApplicationController
  before_action :find_user

  def edit; end

  def update
    if @user.update(user_params)
      @user.send_confirmation_instructions
      redirect_to root_path, notice: t("devise.registrations.signed_up_but_unconfirmed")
    else
      render :edit
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
