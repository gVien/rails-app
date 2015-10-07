class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user  # instance variable so the mailer view can have access
    mail to: user.email, subject: "Account Activation"  # sending the email to this user
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
