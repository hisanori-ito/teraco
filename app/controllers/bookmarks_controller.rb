class BookmarksController < ApplicationController
  
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:index]
  
  def index
    @bookmarks = Bookmark.where(user_id: params[:user_id]).page(params[:page]).per(16)
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
  
  private

  def ensure_correct_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_bookmarks_path(current_user)
    end
  end

end
