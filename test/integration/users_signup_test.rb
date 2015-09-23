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
end
