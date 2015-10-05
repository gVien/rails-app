require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @gai_admin = users(:gai)
    @non_admin = users(:new_user)
  end

  # tests the pagination page
  # 1. login in as an admin user
  # 2. get the user index page
  # 3. verify the index template renders properly
  # 4. verify the div pagination is on the page
  # 5. verify the link of each pagination works and each text is equal to the user name
  # 6. verify that the delete link exists
  # 7. verify that the user count is 1 less (-1) after deleting a user
  test "index as admin including pagination and delete links" do
    log_in_as(@gai_admin)
    get users_path
    assert_template("users/index")
    assert_select "div.pagination"
    users_for_page_1 = User.paginate(page: 1)
    users_for_page_1.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select("a[href=?]", user_path(user), text: "delete") unless user.admin? # or user == @gai_admin
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  # test that the non-admin user cannot delete
  # 1. log in as non admin
  # 2. get the "/users" path (user_path)
  # 3. verify the non-admin user cannot see the delete anchor link
  test "should" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
