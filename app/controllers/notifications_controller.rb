class NotificationsController < ApplicationController
   
  def index
    @notifications = current_user.to_me_notifications.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
