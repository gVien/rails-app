require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:gai)
  end
  # visit the user profile page
  # check for page title, user's name, Gravatar, micropost count, and paginated microposts.
  test "profile page should have contents" do
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    # check if page's title is equal to the full title
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_select "h1>img.gravatar" #checks for img tag /w gravatar class
    assert_match @user.microposts.count.to_s, response.body #check if the count matches with the number inside body (includes all of html, not just body)
    microposts_paginate_1 = @user.microposts.paginate(page: 1)
    # check if each micropost has content
    microposts_paginate_1.each do |micropost|
      assert_match micropost.content, response.body
    end
  end

end
