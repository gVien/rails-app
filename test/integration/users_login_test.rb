require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

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
end
