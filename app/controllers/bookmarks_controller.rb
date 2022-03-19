class BookmarksController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @bookmarks = Bookmark.where(user_id: params[:user_id])
    @user = User.find(params[:user_id])
  end
  
  def create
    @post = Post.find(params[:post_id])
    bookmark = @post.bookmarks.new(user_id: current_user.id)
    bookmark.save
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    bookmark = @post.bookmarks.find_by(user_id: current_user.id)
    if bookmark.present?
      bookmark.destroy
    end
  end
end
