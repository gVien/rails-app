require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear  # clears all deliveries in case if some other test deliver email (note deliveries is an array)
  end

  # test for when user does not enter the required information
  test "invalid sign up information" do
    get signup_path
    # method below is same as
    # before_count = User.count
    # post users_path, ...
    # after_count  = User.count
    # assert_equal before_count, after_count
    # but cleaner
    assert_no_difference "User.count" do
      post users_path, user: { name:  "",
                               email: "noname@invalid",
                               password:              "short",
                               password_confirmation: "pass" }
    end
    assert_template "users/new"
    # check to make sure these elements exists when the sign up has errors, then the test passes
    # printing any of these out shows Nokogiri object, interesting...
    assert_select("div#error_explanation")
    assert_select("div li")
    assert_select("div.field_with_errors")
  end

  # testing if submission is valid (created) and confirm the contents of the database
  #
  test "valid signup information with account activation" do
    get signup_path
    # works similar to assert_no_difference
    # but in this case, we want to see a differene of 1 (that parameter is optinal)
    assert_difference "User.count", 1 do
      # post_via_redirect is used to redirect after post, resulting in rendering of "users/show" template
      post users_path, user: { name: "Gai",
        email: "gai@gai.com",
        password: "password",
        password_confirmation: "password"}
    end
    # the test follows the routine after sign up
    # 1. verify the email is sent out (check size of 1)
    # 2. use assign method to access the @user in creation action of user ctrler
    # 3. verify the account is not activated.
    # 4. log in user
    # 5. verify user is not logged in since it's not activated
    # 6. get the invalid activation token link
    # 7. verify the user is not logged in since it's not activated from the wrong activation link
    # 8. get correct activation token link w/ wrong email
    # 9. verify the user is not logged in
    # 10. get correct activation token link w/ correct email
    # 11. verify user is logged in
    # 12. redirect
    # all other tests shall be the same
    assert_equal 1, ActionMailer::Base.deliveries.size  #check size of email
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token, right email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!

    assert_template "users/show"
    assert is_logged_in?  # this tests the user is logged after signup (if the method returns true, the test passes, otherwise the test fails)
    # assert_not must accept a false argument to pass test, so in this case. flash is not an empty object
    assert_not(flash.empty?)
  end
end
