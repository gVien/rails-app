require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
  end

  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    # the question mark is replaced by the path url inside a[...]
    # e.g. <a href="/about"> ... </a>
    # for the root path, it verifies two links (one for the logo and navigation menu element)
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    assert_select "title", full_title("Sign up")

    # chapter 9 exercise 2
    # tests for additional panels after login
    # log_in_as(@user)
    # assert_select "a[href=?]", user_path(@user)
    # assert_select "a[href=?]", users_path
    # assert_select "a[href=?]", edit_user_path(@user)
    # assert_select "a[href=?]", logout_path
  end
end
