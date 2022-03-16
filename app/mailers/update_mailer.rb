class UpdateMailer < ApplicationMailer
  def send_update(user)
    @name = user.name
    @email = user.email
    mail to: @email, subject: '更新が完了しました'
  end
end