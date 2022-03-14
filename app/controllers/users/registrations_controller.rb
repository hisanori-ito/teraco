class Users::RegistrationsController < Devise::RegistrationsController
  
  def create
    #superでdeviseのcreateアクションを呼ぶ 
    super 
    #NotificationMailerクラスのsend_registrationメソッドを呼び、POSTから受け取ったuserのemailとnameを渡す
    NotificationMailer.send_registration(params[:user][:email],params[:user][:name]).deliver
  end

end