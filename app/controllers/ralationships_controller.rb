class RalationshipsController < ApplicationController
  
  # フォローするとき
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  
  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  # フォロー一覧表示
  def follows
    user = User.find(params[:user_id])
    @users = user.follows
  end

  # フォロワー一覧表示
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
