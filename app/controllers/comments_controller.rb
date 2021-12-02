class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(body: comment_params[:body], commentable_type: params[:commentable_type], commentable_id: params[:commentable_id])
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
