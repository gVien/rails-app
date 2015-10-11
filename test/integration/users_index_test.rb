require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @gai_admin = users(:gai)
    @non_admin = users(:new_user)
    @user0 = users(:user0)
  end

  # tests the pagination page
  # 1. login in as an admin user
  # 2. get the user index page
  # 3. verify the index template renders properly
  # 4. verify the div pagination is on the page
  # 5. verify the link of each pagination works and each text is equal to the user name
  # 6. verify that the delete link exists
  # 7. verify that the user count is 1 less (-1) after deleting a user

  # Chapter 10 (exercise 2).
  # 8. update attribute of activated for user0 to false
  # 9. redirect to the users path
  # 10. Verify that the name of the inactivted user is not shown in the body of html
  # 11. get user0 path
  # 12. verify the site redirects to root path
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

    # Chapter 10 (exercise 2): verify the inactivated is not there
    @user0.update_attribute(:activated, false)
    get users_path
    assert_no_match(/(user 0)/i, response.body)

    # show action test
    get user_path(@user0)
    assert_redirected_to root_url
  end

  # test that the non-admin user cannot delete
  # 1. log in as non admin
  # 2. get the "/users" path (user_path)
  # 3. verify the non-admin user cannot see the delete anchor link

  # Chapter 10 (exercise 2).
  # 8. update attribute of activated for user0 to false
  # 9. redirect to the users path
  # 10. Verify that the name of the inactivted user is not shown in the body of html
  # 11. get user0 path
  # 12. verify the site redirects to root path
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count: 0

    # Chapter 10 (exercise 2): verify the inactivated is not there
    @user0.update_attribute(:activated, false)
    get users_path
    assert_no_match(/(user 0)/i, response.body)

    # show action test
    get user_path(@user0)
    assert_redirected_to root_url
  end
end
