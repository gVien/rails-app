require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:gai)
    @kathy = users(:kathy)
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

  test "should follow the user via html (no js)" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, followed_id: @kathy.id
    end
  end

  test "should follow the user via Ajax call" do
    assert_difference "@user.following.count", 1 do
      xhr :post, relationships_path, followed_id: @kathy.id
    end
  end

  # follow another user
  # define the relationship
  # verify the count is 1 less
  test "should unfollow the user via html" do
    @user.follow(@kathy)
    relationship = @user.active_relationships.find_by(followed_id: @kathy.id)
    assert_difference '@user.following.count', -1 do
      delete(relationship_path(relationship))
    end
  end

  test "should unfollow the user via Ajax call do" do
    @user.follow(@kathy)
    relationship = @user.active_relationships.find_by(followed_id: @kathy.id)
    assert_difference '@user.following.count', -1 do
      xhr(:delete, relationship_path(relationship))
    end
  end
end
