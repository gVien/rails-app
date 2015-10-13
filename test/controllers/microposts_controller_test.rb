require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:gai)
    @micropost = microposts(:most_recent)
    @new_user = users(:new_user)
    @dog = microposts(:dog)
  end

  # 1. verify the count does not change when the user attempts to crate a micropost
  # 2. verify it redirects to login page
  test "should redirect create if user is not logged in" do
    assert_no_difference "Micropost.count" do
      post(:create, micropost: { content: "illegal micropost cannot be created "})
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if user is not logged in" do
    assert_no_difference "Micropost.count" do
      delete(:destroy, id: @micropost)
    end
    assert_redirected_to login_url
  end

  # login as user
  # attempt to delete new user's post (which is dog post)
  # verify the url is redirected to root path
  test "should redirect destroy if user is wrong" do
    log_in_as(@user)
    # note: there is no need to get the link to the new_user's profile
    assert_no_difference "Micropost.count" do
      delete(:destroy, id: @dog)
    end
    assert_redirected_to root_url
  end
end
