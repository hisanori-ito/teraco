class Users::RegistrationsController < Devise::RegistrationsController
  
  before_action :ensure_normal_user, only: :destroy
   
  def create
    #superでdeviseのcreateアクションを呼ぶ
    super
    #NotificationMailerクラスのsend_registrationメソッドを呼び、POSTから受け取ったuserのemailとnameを渡す
    NotificationMailer.send_registration(params[:user][:name], params[:user][:email]).deliver
  end
  
  # ↓ゲストユーザーは退会できない
  def ensure_normal_user
    if resource.email == "guest@guest"
      redirect_to user_path(current_user), alert: "ゲストユーザーは削除できません。"
    end
  end
end