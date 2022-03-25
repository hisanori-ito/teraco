class RelationshipsController < ApplicationController
  
   before_action :authenticate_user!,
  
  # フォローするとき
  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    @user.notification_follow!(current_user)
  end
  
  # フォロー外すとき
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
  end
  
  # フォロー一覧表示
  def follows
    user = User.find(params[:user_id])
    @users = user.follows.page(params[:page]).per(16)
  end

  # フォロワー一覧表示
  def followers
    user = User.find(params[:user_id])
    @users = user.followers.page(params[:page]).per(16)
  end
end
