require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
    @new_user = users(:new_user)
  end

  # login as user
  # get home page
  # verify there is pagination
  # user posts an invalid post
  # verify the user cannot post an invalid post (no differnece in count)
  # verify the error message pops up
  # user posts a valid post
  # verify the user can post a valid post (difference in count of 1)
  # verify the link is redirected to root url after a post
  # verify the post made earlier is on the home page
  # verify there is delete link
  # verify the user can delete its own post
  # get home page of another user
  # verify the user cannot delete another's user post
  test "microposts interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
    assert_no_difference "Micropost.count" do
      post(microposts_path, micropost: { content: ""})
    end
    assert_select 'div#error_explanation'

    assert_difference "Micropost.count", 1 do
      post(microposts_path, micropost: { content: "valid post"})
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match "valid post", response.body

    assert_select "a", text: "delete"
    assert_difference "Micropost.count", -1 do
      delete(micropost_path(@user.microposts.paginate(page: 1).first))
    end

    get user_path(@new_user)
    assert_select "a", text: "delete", count: 0 # delete link is not there
  end

  # ch11, ex 2: testing the sidebar count
  # login as user
  # get root_path
  # verify the count number is in the body
  # login as another user with zero micropost
  # get root path
  # verify the 0 count number is in the body
  # create a post
  # get the root path again
  # verify the new count matches with the body (this also verifies the pluralization of "micropost")
  test "microposts sidebar count" do
    # count above 0
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # count of 0
    kathy = users(:kathy)
    log_in_as(kathy)
    get root_path
    assert_match "0 microposts", response.body
    # create a post and check
    kathy.microposts.create!(content: "new post")
    get root_path
    assert_match "#{kathy.microposts.count} micropost", response.body
  end
end
