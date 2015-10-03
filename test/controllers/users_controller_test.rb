require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:gai)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # this tests the before_action method (edit & update) in the users controller
  # the two tests will work with the before_action (note the test fails if it's uncomment out)
  # we need to test that the site is redirected to the login page if a guest tries to access "users/1/edit" if he/she is not logged in
  test "should redirect to login page if a user is not logged in" do
    # attempt to access the edit link of a user
    get :edit, id: @user
    # check if the flash is not empty
    assert_not flash.empty? # if it is not empty, it means it's working
    # check if the url is a redirected url
    assert_redirected_to login_url
  end

  test "should redirect update if a user is not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
