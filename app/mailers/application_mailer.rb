# use this command to generate account activation/password reset
# rails g mailer UserMailer account_activation password_reset

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'mailer'
end
