require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  # define setup (this runs when the test is loaded) for the login test
  def setup
    @user = users(:gai)
  end

  # add integration test for invalid login information
  # the process is listed below
  # 1. Visit the login path.
  # 2. Verify that the new sessions form renders properly.
  # 3. Post to the sessions path with an invalid params hash.
  # 4. Verify that the new sessions form gets re-rendered and that a flash message appears.
  # 5. Visit another page (such as the Home page).
  # 6. Verify that the flash message doesn’t appear on the new page.
  test "login with invalid information" do
    get login_path # #1
    assert_template "sessions/new" # #2
    post login_path, session: { email: "", password: ""}  # #3
    assert_template "sessions/new"  # #4
    assert_not flash.empty? # test only pass if flash.empty is false. # 4
    get root_path # #5
    assert flash.empty?  # #6
  end

  # see User model for more description but
  # the flow will be the following:
  # 1. Visit the login path.
  # 2. Post valid information to the sessions path.
  # 3. Verify that the login link disappears.
  # 4. Verify that a logout link appears
  # 5. Verify that a profile link appears.
  # type this to test the file
  # bundle exec rake test TEST=test/integration/users_login_test.rb
  # can add 'TESTOPTS="--name test_login_with_valid_information" to test only the test below'
  test "login with valid information" do
    get login_path  # 1
    post login_path, session: { email: @user.email, password: "123456" }  #2
    assert_redirected_to @user  #2 (assert_redirected_to checks the right redirect target)
    follow_redirect!    #2 (this visits the target page)
    assert_template("users/show")   #2
    assert_select "a[href=?]", login_path, count: 0   #3 (this test if the login_path url has a count of 0, meaning it's no longer there)
    assert_select "a[href=?]", logout_path  #4 (this test for logout url is there in the HTML)
    assert_select "a[href=?]", user_path(@user)   #5 (test if user, e.g. /users/1 is there)
  end
end
