class UserMailer < ApplicationMailer

  # sends activation email
  def account_activation(user)
    @user = user  # instance variable so the mailer view can have access
    mail to: user.email, subject: "Account Activation"  # sending the email to this user
  end

  # sends password reset instructions email
  def password_reset(user)
    @user = user  # instance variable so the mailer view can have access
    mail to: @user.email, subject: "Password Reset"
  end
end
