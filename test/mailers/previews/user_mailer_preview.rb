# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # we are sending the email to the user below
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user) #account_activation defined in user_mailer.rb in mailer folder
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user) # defined in user_mailer.rb in mailer folder
  end

end
