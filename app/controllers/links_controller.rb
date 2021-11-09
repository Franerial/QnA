class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      flash.now[:notice] = "You do not have permission to do that."
    end

    if @link.linkable.instance_of?(Answer)
      redirect_to @link.linkable.question
    else
      redirect_to @link.linkable
    end
  end
end
