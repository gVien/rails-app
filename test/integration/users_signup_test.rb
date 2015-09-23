require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
  end

  # testing if submission is valid (created) and confirm the contents of the database
  test "valid signup information" do
    get signup_path
    # works similar to assert_no_difference
    # but in this case, we want to see a differene of 1 (that parameter is optinal)
    assert_difference "User.count", 1 do
      # post_via_redirect is used to redirect after post, resulting in rendering of "users/show" template
      post_via_redirect users_path, user: { name: "Gai",
        email: "gai@gai.com",
        password: "password",
        password_confirmation: "password"}
    end
    assert_template "users/show"
  end
end
