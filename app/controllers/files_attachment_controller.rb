class FilesAttachmentController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    if current_user.author_of?(@file.record)
      @file.purge
    else
      flash.now[:notice] = "You do not have permission to do that."
    end

    redirect_to @file.record
  end
end
