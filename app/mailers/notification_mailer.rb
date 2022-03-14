class NotificationMailer < ApplicationMailer
  
  def send_registration(name, email)
    @name = name
    mail to: email,
         subject: "ご登録ありがとうございます"
　end
