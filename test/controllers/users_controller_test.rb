require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:gai)
    @second_user = users(:new_user)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # verify that logged is required if the non-logged in user attempts to access the index page
  test "redirect index if not logged in" do
    get :index
    assert_redirected_to login_url
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

  # this integration test ensures a user cannot edit/update the profilt of another user
  # the flow is (based on users in users.yml):
  # 1. second_user logs in
  # 2. second user tries to edit gai's profile
  # 3. verify that the flash is empty
  # 4. verify that edit link is redirected to root url (as defined in user ctrler correct_user method)
  test "should redirect edit if logged in as wrong user" do
    log_in_as(@second_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update if logged in as wrong user" do
    log_in_as(@second_user)
    patch :update, id: @user, user: { name: @user.name,
                                      email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # tests for destroy feature in user controller
  # first test:
  # 1. verify that non-admin user cannot delete a user (using assert no difference)
  # 2. verify that the site redirect to login page if not logged in
  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete(:destroy, id: @user)
    end
    assert_redirected_to login_url
  end

  # second test
  # second test:
  # 1. login as non-admin user
  # 2. verify that non-admin user cannot delete a user (using assert no difference)
  # 3. verify that the site redirect to root url page if not logged in as admin
  test "should redirect destroy when not logged in as admin user" do
    log_in_as(@second_user)
    assert_no_difference "User.count" do
      delete(:destroy, id: @user)
    end
    assert_redirected_to root_url
  end

  # ch9 ex3: test to make sure the admin attribute in model cannot be editable from the web
  # add :admin in side user_params in users_controller to fail this test initially, then remove it to pass
  # (this is to make sure the test is doing the right thing)
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@second_user)
    assert_not(@second_user.admin?) # to pass, arg should returns false
    # now the second user tries to change the admin attribute to true
    patch :update, id: @second_user, user: { password: "123456",
                                             password_confirmation: "123456",
                                             admin: true }
    # must reload so the changes above will take effect
    # we still want to see that the admin attribute is false after reload
    assert_not @second_user.reload.admin?
  end

  # test redirect following & follower if not log in
  test "should redirect following if not logged in" do
    get :following, id: @second_user #get list of following for second user (/users/1/following)
    assert_redirected_to login_url
  end

  test "should redirect follower if not logged in" do
    get :followers, id: @second_user #get list of followers for second user
    assert_redirected_to login_url
  end
end
