class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    authorize! :destroy, @link.linkable

    @link.destroy

    if @link.linkable.instance_of?(Answer)
      redirect_to @link.linkable.question
    else
      redirect_to @link.linkable
    end
  end
end
