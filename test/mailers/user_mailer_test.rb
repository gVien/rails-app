require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:gai)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from  # this is defined in ../mailers/application_mail.rb
    # regular expression can also be used in assert_match, e.g. assert_match /\w+/, 'foobar' (returns true)
    # or string such as assert_match 'baz', 'foobar' (# false)
    assert_match user.name.capitalize, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded # CGI::escape(user.email) is the g@example.com encoded to g%40example.com
  end

  test "password_reset" do
    user = users(:gai)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password Reset", mail.subject
    assert_equal [user.email], mail.to  # send to user's email
    assert_equal ["from@example.com"], mail.from  # this is defined in ../mailers/application_mail.rb
    assert_match user.reset_token, mail.body.encoded  # checking that the token matches with the token found in the email's body
    assert_match CGI::escape(user.email), mail.body.encoded # CGI::escape(user.email) is the g@example.com encoded to g%40example.com (this test checks for the user's email matches with the one found in the body of email)
  end

end
