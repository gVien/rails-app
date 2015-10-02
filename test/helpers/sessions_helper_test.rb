# this is a helper to test the remember branch in the current_user method in sessionhelpers (controller)

require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  # this will test the remember branch for the current user. The flow goes like this:
  # 1. Define a user variable using the fixtures.
  # 2. Call the remember method to remember the given user.
  # 3. Verify that current_user is equal to the given user.

  def setup
    @user = users(:gai)
    remember(@user)
  end

  # this test the code block within the else in current_user method
  # we want to make sure if the session is nil, it gets to the else and returns a user
  test "current_user returns right user when session is nil (the else in current user)" do
    # assert_equal(<expected>, <actual>)
    assert_equal(@user, current_user) # test passes if they are equal
    assert(is_logged_in?) # test passes if the user is loggedin
  end

  # check current_user is nil if the user's remember digest doesn't match with the remember token
  # which will test the nested if clause inside the else statement (the authenticated? expression)
  # to verify if this test works, remove the authenticated? expression
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil(current_user)
  end
end