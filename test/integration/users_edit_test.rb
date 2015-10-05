require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
  end

  # we will test the unsuccessful edit
  # 1. visit the edit path
  # 2. verify that the new sessions form renders properly
  # 3. patch (update) the user
  # 4. verify that the template is still there (since it's an unsuccessful edit)
  test "unsuccessful edit of user" do
    log_in_as(@user)
    get edit_user_path @user
    assert_template("users/edit") # from users folder
    patch user_path(@user), user: { name: "gai",
                                    email: "gai@example.com",
                                    password: "123",
                                    password_confirmation: "1" }  #patch also clicks on button too?
    assert_template("users/edit")
  end

  # similar to unsuccessful edit test but this time
  # we will submit a valid information
  # check for nonempty flash message
  # successful redirect to the profile page and verify the user's information is changed correctly in the database
  # password + password_confirmation are left blank (in case if the useres don't want to update it)
  # update with friendly forwarding (9.2.3):
  # forward to the same destination (where they wanted to go but the site requires login) after user is logged in
  # note the log_in_as and get edit_user_path are reversed
  # ** we will verify that the redirect is redirecting to the same location
  test "successful edit a user with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user) unless session[:forwarding_url].nil?  # **, unless statement from ch9 exercise 1
    # assert_template "users/edit"  # no longer needed with friendly forwarding
    name = "gai"  # for verification below
    email = "gai@gai.com" # for verification below
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty? #passes if flash.empty is true
    assert_redirected_to @user
    @user.reload  # reload the user's values from the database (since we updated it)

    # verifying the database has been changed
    assert_equal(name, @user.name)  # assert_equal(expect, actual)
    assert_equal(email, @user.email)
  end
end
