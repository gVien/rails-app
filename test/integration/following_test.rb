require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:gai)
    log_in_as(@user)
  end

  # test for following page (not comprehensive since we want to make sure it's working)
  # get following for the specific user
  # verify the user following list is not empty
  # verify "following" word is on the page
  # verify following list count is in the body
  # verify the link for each item in the following list is active
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match "Following", response.body
    assert_match @user.following.count.to_s, response.body
    @user.following.each { |user| assert_select "a[href=?]", user_path(user)}
  end

  # test for followers page
  test "follower page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match "Followers", response.body
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each { |user| assert_select "a[href=?]", user_path(user)}
  end
end
