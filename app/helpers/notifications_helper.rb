module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.to_me_notifications.where(checked: false)
  end
end
