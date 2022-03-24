class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      @post.notification_comment!(current_user, @comment.id)
      @comment = Comment.new
    else
      render "error"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    Comment.find(params[:id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
