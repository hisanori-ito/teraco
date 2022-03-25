class FavoritesController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @favorites = Favorite.where(user_id: params[:user_id]).page(params[:page]).per(16)
    @user = User.find(params[:user_id])
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    @post.notification_favorite!(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
