class Users::RegistrationsController < Devise::RegistrationsController

  def create
    #superでdeviseのcreateアクションを呼ぶ
    super
    #NotificationMailerクラスのsend_registrationメソッドを呼び、POSTから受け取ったuserのemailとnameを渡す
    NotificationMailer.send_registration(params[:user][:name], params[:user][:email]).deliver
  end
end