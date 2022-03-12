class BookmarksController < ApplicationController
  
  def index
    @bookmarks = Bookmark.where(user_id: params[:user_id])
    @user = User.find(params[:user_id])
  end
  
  def create
    post = Post.find(params[:post_id])
    bookmark = post.bookmarks.new(user_id: current_user.id)
    bookmark.save
    redirect_to post_path(post)
  end
  
  def destroy
    post = Post.find(params[:post_id])
    bookmark = post.bookmarks.find_by(user_id: current_user.id)
    if bookmark.present?
      bookmark.destroy
      redirect_to post_path(post)
    else
      redirect_to post_path(post)
    end
  end
end
