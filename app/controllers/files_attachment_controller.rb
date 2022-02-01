class FilesAttachmentController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    authorize! :destroy, @file.record
    @file.purge

    if @file.record.instance_of?(Answer)
      redirect_to @file.record.question
    else
      redirect_to @file.record
    end
  end
end
